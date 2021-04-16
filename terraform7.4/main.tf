provider "aws" {
  region = "eu-central-1"
}


locals {
  web_instance_type = {
    stage = "t2.micro"
    prod = "t2.micro"
  }
//  web_instance_count = {
//    //stage = 0
//    prod = 1
//  }
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

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type[terraform.workspace]

}

