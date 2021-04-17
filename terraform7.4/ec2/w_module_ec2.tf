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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "my-cluster"
  instance_count = 1

  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  //key_name = "user1"
  monitoring = true
  subnet_id   = aws_subnet.my_subnet.id

  tags = {
    Terraform = "true"
    Environment = "netology-dev"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block = "172.16.10.0/24"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.id
}

