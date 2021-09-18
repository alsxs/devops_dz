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

resource "aws_instance" "ec2_pub" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  monitoring = true
  subnet_id   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name= "aws-key"
  vpc_security_group_ids = [aws_security_group.main.id]
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "als"
      private_key = file("~/run/temp/aws-key")
      timeout     = "4m"
   }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.my_vpc.id
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_key_pair" "aws_pk" {
  key_name   = "aws-key"
  public_key = var.pk
}
