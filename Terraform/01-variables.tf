# variables.tf

# AWS Region Variable
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
# Key Pair Name Variable
variable "key_pair_name" {
  description = "The name of the AWS key pair to use for EC2 instances"
  type        = string
  default     = "ec2_ssh_key"
}
# EC2 Instance Type Variable
variable "instance_type" {
  description = "The type of EC2 instance to use"
  type        = string
  default     = "t2.micro"
}

# First VPC CIDR
variable "first_vpc_cidr" {
  description = "The CIDR block for the first VPC"
  type        = string
  default     = "10.0.0.0/24"
}

# Public Subnet CIDR
variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet in the first VPC"
  type        = string
  default     = "10.0.0.0/25"
}

# Second VPC CIDR
variable "second_vpc_cidr" {
  description = "The CIDR block for the second VPC"
  type        = string
  default     = "20.0.0.0/24"
}

# Private Subnet CIDR
variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet in the first VPC"
  type        = string
  default     = "20.0.0.0/25"
}
