resource "aws_vpc" "vpc_ITI" {
 cidr_block= var.VPC-cidr
 tags = {
    Name = "vpc_ITI"
  }  
}

#use count
resource "aws_subnet" "Subnet" {
  count = length(var.Subnet-Cidr)
  #0 for public subnet && 1 for private
  cidr_block = var.Subnet-Cidr[count.index]
  vpc_id     = aws_vpc.vpc_ITI.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = var.subnet-tag-name[count.index]
  }
}


resource "aws_route_table" "publicRoute" {
  vpc_id = aws_vpc.vpc_ITI.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block= "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "publicRoute"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Subnet[0].id
  route_table_id = aws_route_table.publicRoute.id
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_ITI.id
  tags = {
    Name = "gw"
  }
}

resource "aws_route_table" "privateRoute" {
  vpc_id = aws_vpc.vpc_ITI.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw-NAT.id
  }

  tags = {
    Name = "privateRoute"
  }
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.Subnet[1].id
  route_table_id = aws_route_table.privateRoute.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "gw-NAT" {
  subnet_id= aws_subnet.Subnet[0].id
  allocation_id = aws_eip.nat_gateway.id

  tags = {
    Name = "gw NAT"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}