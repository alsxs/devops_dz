resource "aws_s3_bucket" "s3buck" {
  bucket = "dz152-270921"
  acl    = "private"
  versioning {
    enabled = false
  }
  tags = { Name = "Bucket" }
}

resource "aws_s3_bucket_object" "pic" {
  bucket = aws_s3_bucket.s3buck.id
  acl    = "public-read"
  key    = "pic.gif"
  source = "media/pic.gif"
}

resource "aws_s3_bucket_public_access_block" "s3allow" {
  bucket = aws_s3_bucket.s3buck.id
  block_public_acls   = false
  block_public_policy = false
}

data "aws_s3_bucket" "s3buck" {
  bucket = aws_s3_bucket.s3buck.id
}

data "aws_s3_bucket_object" "img" {
  bucket = aws_s3_bucket.s3buck.id
  key    = aws_s3_bucket_object.pic.id
}


resource "aws_route53_zone" "dns" {
  name = "dns-dz152-270921.com"
  vpc {
    vpc_id = aws_vpc.my_vpc.id
  }
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.dns.zone_id
  name    = "www.dns-dz152-270921.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.my_elb.dns_name]
}

resource "aws_elb" "my_elb" {
  name  = "my-elb"
  subnets = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id, aws_subnet.public_subnet3.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 15
  }

  security_groups = [aws_security_group.main.id]

  cross_zone_load_balancing   = true
  idle_timeout                = 120
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "my_elb"
  }
}

resource "aws_autoscaling_group" "autoscale_ec2" {
  name                 = "autoscale-ec2"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 3
  max_size             = 6
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true

  vpc_zone_identifier  = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id, aws_subnet.public_subnet3.id]

  load_balancers = [aws_elb.my_elb.id]

  lifecycle {
    create_before_destroy = true
  }
}
