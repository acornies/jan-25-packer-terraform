resource "aws_vpc" "vpc_east" {
  cidr_block           = var.cidr_vpc_east
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw_east" {
  vpc_id = aws_vpc.vpc_east.id
}

resource "aws_subnet" "subnet_public_east" {
  vpc_id            = aws_vpc.vpc_east.id
  cidr_block        = var.cidr_subnet_east
  availability_zone = "us-east-2a"
}

resource "aws_route_table" "rtb_public_east" {
  vpc_id = aws_vpc.vpc_east.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_east.id
  }
}

resource "aws_route_table_association" "rta_subnet_public_east" {
  subnet_id      = aws_subnet.subnet_public_east.id
  route_table_id = aws_route_table.rtb_public_east.id
}

resource "aws_security_group" "ssh_east" {
  name   = "ssh_22"
  vpc_id = aws_vpc.vpc_east.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["10.1.0.0/24"]
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http_east" {
  name   = "http_80"
  vpc_id = aws_vpc.vpc_east.id

  # SSH access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ldap_east" {
  name   = "ldap_389"
  vpc_id = aws_vpc.vpc_east.id

  # SSH access from the VPC
  ingress {
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    # cidr_blocks = ["10.1.0.0/24"]
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_egress_east" {
  name   = "allow_egress"
  vpc_id = aws_vpc.vpc_east.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}