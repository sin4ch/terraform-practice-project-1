provider "aws" {
  region = "us-east-1"
}

# ----------------------------------------------
# TERRAFORM PROJECT: SETTING UP AN AWS INFRA
# Create vpc
# Create route table
# Create internet gateway
# Create subnet
# Create route table association
# Create security group
# Create security group ingress rules
# Create security group egress rules
# ----------------------------------------------

# VPC
resource "aws_vpc" "my_first_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "development" 
  }
}

# Internet gateway
resource "aws_internet_gateway" "my_first_gw" {
  vpc_id = aws_vpc.my_first_vpc.id
}

# Route table
resource "aws_route_table" "my_first_route_table" {
  vpc_id = aws_vpc.my_first_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_first_gw.id
  }
  tags = {
    Name = "development"
  }
}

# Subnet
resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.my_first_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" 
  tags = {
    Name = "dev_subnet_1"
  }
}

# Route table association
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.my_first_route_table.id
}

# Security group
resource "aws_security_group" "my_first_security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_first_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

# Security group ingress rules for IPv4
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.my_first_security_group.id
  cidr_ipv4         = aws_vpc.my_first_vpc.cidr_block
  description = "Allow HTTPS inbound traffic"
  from_port         = 443
  to_port           = 443
    ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.my_first_security_group.id
  cidr_ipv4         = aws_vpc.my_first_vpc.cidr_block
  description = "Allow HTTP inbound traffic"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.my_first_security_group.id
  cidr_ipv4         = aws_vpc.my_first_vpc.cidr_block
  description = "Allow SSH inbound traffic"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Security group egress rules for IPv4
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_first_security_group.id
  cidr_ipv4         = aws_vpc.my_first_vpc.cidr_block
  description = "Allow all outbound traffic"
  ip_protocol       = "-1" # semantically equivalent to all ports
}






