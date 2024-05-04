// Networking

resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
  tags = {
    Name = "redes-tpe-vpc"
  }
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet_configs)

  cidr_block        = cidrsubnet(var.base_cidr_block, var.subnet_configs[count.index].subnet_bits, count.index + 1)
  availability_zone = var.subnet_configs[count.index].availability_zone
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = var.subnet_configs[count.index].map_public_ip_on_launch 


  tags = {
    Name        = var.subnet_configs[count.index].name
    Environment = "Development"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_public_association" {
  count = 2 
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
  domain = "vpc"
  tags = {
    Name = "redes-tpe-eip-nat"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnets[0].id # nat should be in public subnet

  tags = {
    Name = "NAT GW for private subnet"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}

resource "aws_route_table_association" "rt_private_association" {
  subnet_id      = aws_subnet.subnets[2].id
  route_table_id = aws_route_table.rt_private.id
}


// SGs

resource "aws_security_group" "sg_elb" {

  name   = "redes-tpe-sg-elb"
  vpc_id = aws_vpc.main.id
  
  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "Allow https request from anywhere"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "sg_ec2" {
  name   = "redes-tpe-sg-ec2"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow http request from Load Balancer"
    protocol        = "tcp"
    from_port       = 80 
    to_port         = 80
    security_groups = [aws_security_group.sg_elb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// ELBs

resource "aws_lb" "lb" {
  name               = "redes-tpe-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_elb.id]
  subnets            = [aws_subnet.subnets[0].id, aws_subnet.subnets[1].id]
  depends_on         = [aws_internet_gateway.igw]
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "redes-tpe-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}



// EC2 + ASG 

resource "aws_launch_template" "asg_template" {
  name_prefix   = "redes-tpe-asg-template"
  image_id      = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  user_data     = filebase64(var.user_data)

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.subnets[2].id
    security_groups             = [aws_security_group.sg_ec2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "redes-tpe-ec2" 
    }
  }
}

resource "aws_autoscaling_group" "asg" {

  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  vpc_zone_identifier = [aws_subnet.subnets[2].id]

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }
}