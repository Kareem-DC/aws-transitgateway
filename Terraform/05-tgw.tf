# The Transit Gateway configuration for connecting the VPCs
# This will feature the Transit Gateway, The TGW Attachments
# And the necessary route table associations for the VPCs

# The TGW
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway for connecting the VPCs"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = {
    Name = "tgw"
  }
}

# The first TGW Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "first_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.first_vpc.id
  subnet_ids         = [aws_subnet.first_vpc_public_subnet.id]

  tags = {
    Name = "first_tgwa"
  }
}

# The second TGW Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "second_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.second_vpc.id
  subnet_ids         = [aws_subnet.second_vpc_private_subnet.id]

  tags = {
    Name = "second_tgwa"
  }
}

# First VPC Public RT route to the Second VPC
# Via the TGW
resource "aws_route" "public_to_private_vpc" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.second_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.first_vpc_attachment]
}

# The Second VPC Private RT route to the First VPC
resource "aws_default_route_table" "second_default" {
  default_route_table_id = aws_vpc.second_vpc.default_route_table_id

  route {
    cidr_block         = var.first_vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "second_default_rt"
  }

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.second_vpc_attachment]
}