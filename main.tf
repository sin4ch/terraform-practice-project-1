provider aws {
  region = "us-east-1"
}

# ----------------------------------------------
# TERRAFORM PROJECT: SETTING UP AN AWS INFRA
# Create vpc
# Create subnet
# Create route table
# Create internet gateway
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
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.my_first_gw.id
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
    Name = "dev_swubnet_1"
  }
}

# Route Table
resource "aws_route_table_association" "my_route_table_" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.my_first_route_tabler.id
}

# Security Group
resource "aws_security_group" "my_first_security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_first_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.my_first_vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = aws_vpc.my_first_vpc.ipv6_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.my_first_vpc.cidr_block
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}






