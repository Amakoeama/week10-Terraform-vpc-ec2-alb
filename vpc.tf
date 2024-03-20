resource "aws_vpc" "vpc01" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Terraform-vpc"
    env  = "dev"
    Team = "DevOps"
  }
}
resource "aws_internet_gateway" "Gateway01" {
  vpc_id = aws_vpc.vpc01.id

}
#Public Subnet
resource "aws_subnet" "Public_sub01" {
  availability_zone       = "us-east-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc01.id
  tags = {
    Name = "public-subnet-01"
    env  = "dev"
  }

}
resource "aws_subnet" "Public_sub02" {
  availability_zone       = "us-east-1b"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc01.id
  tags = {
    Name = "public-subnet-02"
    env  = "dev"
  }
}
#Private Subnet
resource "aws_subnet" "Private_sub01" {
  availability_zone = "us-east-1a"
  cidr_block        = "192.168.3.0/24"
  vpc_id            = aws_vpc.vpc01.id
  tags = {
    Name = "private-subnet-01"
    env  = "dev"
  }

}
resource "aws_subnet" "Private_sub02" {
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.4.0/24"
  vpc_id            = aws_vpc.vpc01.id
  tags = {
    Name = "private-subnet-02"
    env  = "dev"
  }
}
#Public Route Table
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Gateway01.id
  }
}
# Elastis ip and NAT gateway
resource "aws_eip" "Elastic_ip" {

}
resource "aws_nat_gateway" "nat01" {
  allocation_id = aws_eip.Elastic_ip.id
  subnet_id     = aws_subnet.Public_sub01.id
}

#Private Route Table
resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Gateway01.id
  }

}

## Subnet association

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.Private_sub01.id
  route_table_id = aws_route_table.Private_RT.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.Private_sub02.id
  route_table_id = aws_route_table.Private_RT.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.Public_sub01.id
  route_table_id = aws_route_table.Public_RT.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.Public_sub02.id
  route_table_id = aws_route_table.Public_RT.id
}