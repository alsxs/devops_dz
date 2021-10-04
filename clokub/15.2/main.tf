provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.32.0/24"
  availability_zone =  "eu-central-1a"
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.33.0/24"
  availability_zone =  "eu-central-1b"
}

resource "aws_subnet" "public_subnet3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.34.0/24"
  availability_zone =  "eu-central-1c"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.96.0/19"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.my_vpc.id
  route     {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "rt_priv" {
  vpc_id = aws_vpc.my_vpc.id
  route     {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat_priv.id
  }
}

resource "aws_nat_gateway" "nat_priv" {
  allocation_id = aws_eip.ip_priv.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "rt_assoc_pub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "rt_assoc_pub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "rt_assoc_pub3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_route_table_association" "rt_assoc_priv" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt_priv.id
}

resource "aws_eip" "ip_priv" {
  vpc      = true
  #instance = aws_instance.ec2_priv.id

}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
