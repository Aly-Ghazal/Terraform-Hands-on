resource "aws_vpc" "vpc_ITI" {
 cidr_block       = "10.0.0.0/16"
 tags = {
    Name = "vpc_ITI"
  }  
}


resource "aws_subnet" "PublicSubnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.vpc_ITI.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "PublicSubnet"
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
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.publicRoute.id
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_ITI.id

  tags = {
    Name = "gw"
  }
}
