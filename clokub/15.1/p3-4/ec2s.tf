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
//      type        = "ssh"
//      host        = self.public_ip
//      user        = "ubuntu"
      private_key = file("~/run/temp/aws-key")
      timeout     = "4m"
   }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "ec2_pub"
  }
}

resource "aws_instance" "ec2_priv" {
  ami           = "ami-0764964fdfe99bc31"
  instance_type = "t2.micro"
  monitoring = true
  subnet_id   = aws_subnet.private_subnet.id
  #associate_public_ip_address = true
  key_name= "aws-key"
  vpc_security_group_ids = [aws_security_group.main.id]
  connection {
//      type        = "ssh"
//      user        = "ubuntu"
//      host        = self.public_ip
      private_key = file("~/run/temp/aws-key")
      timeout     = "4m"
   }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "ec2_priv"
  }
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.my_vpc.id
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "aws_pk" {
  key_name   = "aws-key"
  public_key = var.pk
}