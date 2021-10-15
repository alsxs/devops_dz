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

//resource "aws_instance" "ec2_pub" {
//  ami           = data.aws_ami.ubuntu.id
//  instance_type = "t2.micro"
//  monitoring = true
////  subnet_id   = aws_subnet.public_subnet.id
//  associate_public_ip_address = true
//  key_name= "aws-key"
//  vpc_security_group_ids = [aws_security_group.main.id]
//  connection {
////      type        = "ssh"
////      host        = self.public_ip
////      user        = "ubuntu"
//      private_key = file("~/run/temp/aws-key")
//      timeout     = "4m"
//   }
//  lifecycle {
//    create_before_destroy = true
//  }
//  tags = {
//    Name = "ec2_pub"
//  }
//}

resource "aws_instance" "ec2_priv" {
  ami           = data.aws_ami.ubuntu.id
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

//resource "aws_network_interface" "statip" {
//  subnet_id = aws_subnet.private_subnet.id
//  private_ips = ["172.31.96.12"]
//  security_groups = [aws_security_group.main.id]
//
//  attachment {
//    instance = aws_instance.ec2_priv.id
//    device_index = 1
//  }
//}

data "template_file" "bootstrap" {
  template = file("bootstrap.tpl")
  vars = {
    url  = data.aws_s3_bucket.s3buck.bucket_domain_name
    file = data.aws_s3_bucket_object.img.key
  }
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "dz152-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.main.id]
  key_name                    = "aws-key"
  //associate_public_ip_address = true

  user_data = data.template_file.bootstrap.rendered
}




