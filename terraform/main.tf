provider "aws" {
  region = "eu-central-1"
}


locals {
  web_instance_type = {
    stage = "t2.nano"
    prod = "t2.micro"
  }
  web_instance_count = {
    stage = 1
    prod = 2
  }
  web_instances = {
    stage = ["0"]
    prod  = ["0", "1"]
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

//resource "aws_instance" "web" {
//  ami           = data.aws_ami.ubuntu.id
//  instance_type = local.web_instance_type[terraform.workspace]
//  count         = local.web_instance_count[terraform.workspace]
//  lifecycle {
//    create_before_destroy = true
//  }
//}

resource "aws_instance" "web_foreach" {
  for_each = toset(local.web_instances[terraform.workspace])
  ami = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type[terraform.workspace]

  tags = {
    Name = "Server_${each.value}_№${each.key}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
