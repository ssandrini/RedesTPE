resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
  tags = {
    Name = "redes-tpe-vpc"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnets" {
  count = length(var.subnet_configs)

  cidr_block              = cidrsubnet(var.base_cidr_block, var.subnet_configs[count.index].subnet_bits, count.index + 1)
  availability_zone       = var.subnet_configs[count.index].availability_zone
  vpc_id                  = aws_vpc.main.id
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
  count          = 2
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"
  tags = {
    Name = "redes-tpe-eip-nat"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnets[0].id

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
  count          = 2
  subnet_id      = aws_subnet.subnets[count.index + 2].id
  route_table_id = aws_route_table.rt_private.id
}