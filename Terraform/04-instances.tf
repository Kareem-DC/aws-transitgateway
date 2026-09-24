# EC2 Instances configuration for the VPCs
# The Public EC2 instance in the first VPC
# The Private EC2 instance in the second VPC
# Both instances will use the key pair generated in the previous step

# The Data for the AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# The Public EC2 instance in the first VPC
resource "aws_instance" "public_ec2" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = aws_subnet.first_vpc_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<html><h1>Welcome to Whizlabs Public Server</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "first_vpc_ec2"
  }
}


# The Private EC2 instance in the second VPC
resource "aws_instance" "second_vpc_ec2" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.second_vpc_private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name = "second_vpc_ec2"
  }
}