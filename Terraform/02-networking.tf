# Networking configuration for the VPCs and subnets
# The Internet Gateway and the Route Tables for the public internet

# First VPC
resource "aws_vpc" "first_vpc" {
  cidr_block           = var.first_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "first_vpc"
  }
}

# First VPC Public Subnet
resource "aws_subnet" "first_vpc_public_subnet" {
  vpc_id                  = aws_vpc.first_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "first_vpc_public_subnet"
  }
}

# The Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "igw"
  }
}

# The Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "public_rt"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.first_vpc_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# The Route to the Internet Gateway
resource "aws_route" "public_rt_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Second VPC
resource "aws_vpc" "second_vpc" {
  cidr_block           = var.second_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "second_vpc"
  }
}

# Private Subnet for the Second VPC
resource "aws_subnet" "second_vpc_private_subnet" {
  vpc_id                  = aws_vpc.second_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "second_vpc_private_subnet"
  }
}
