# Outputs

output "first_vpc_id" {
  value = aws_vpc.first_vpc.id
}

output "second_vpc_id" {
  value = aws_vpc.second_vpc.id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.tgw.id
}

output "first_ec2_public_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "second_ec2_private_ip" {
  value = aws_instance.second_vpc_ec2.private_ip
}

output "key_pair_name" {
  value = aws_key_pair.ec2_key.key_name
}

output "private_key_path" {
  value = local_file.private_key.filename
}