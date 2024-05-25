resource "aws_security_group" "sg_elb" {

  name   = "redes-tpe-sg-elb"
  vpc_id = var.main_vpc_id

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
  vpc_id = var.main_vpc_id

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

resource "aws_lb" "lb" {
  name               = "redes-tpe-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_elb.id]
  subnets            = [var.subnets_ids[0], var.subnets_ids[1]]
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "redes-tpe-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.main_vpc_id
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

resource "aws_launch_template" "asg_template" {
  name_prefix   = "redes-tpe-asg-template"
  image_id      = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  user_data     = filebase64(var.user_data)

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = var.subnets_ids[2]
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

  vpc_zone_identifier = [var.subnets_ids[2]]

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }

}