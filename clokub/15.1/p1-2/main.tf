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
  instance_tenancy = "default"
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.31.32.0/19"
}

//resource "aws_subnet" "private_subnet" {
//  vpc_id            = aws_vpc.my_vpc.id
//  cidr_block = "172.31.96.0/19"
//}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "rt_pub" {
  vpc_id = aws_vpc.my_vpc.id
  route     {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_pub.id
}

//resource "aws_eip" "ip_pub" {
//  vpc      = true
//}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}