# Security Groups configuration for the VPCs
# The Security Group to SSH and HTTP for the Public EC2
# The Security Group to SSH into the Private EC2
# And the key pair for SSH access

# First Security Group for the First VPC
resource "aws_security_group" "public_ec2_sg" {
  name        = "public_ec2_sg"
  description = "Security group for public EC2 instances in the first VPC"
  vpc_id      = aws_vpc.first_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_ec2_sg"
  }
}

# Second Security Group for the Second VPC
resource "aws_security_group" "private_ec2_sg" {
  name        = "private_ec2_sg"
  description = "Security group for private EC2 instances in the second VPC"
  vpc_id      = aws_vpc.second_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_ec2_sg"
  }
}

# The Key Pair

# This is to generate a Key Pair by Terraform
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# This will create an AWS key pair using the generated private key
resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = var.key_pair_name
  }
}

# Local File
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/${var.key_pair_name}.pem"
  file_permission = "0400"
}