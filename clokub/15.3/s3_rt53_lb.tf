resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "as_s3" {
  route_table_id  = aws_route_table.rt_priv.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.s3buck.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "Access-to-specific-VPCE-only"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.s3buck.arn,
          "${aws_s3_bucket.s3buck.arn}/*",
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = aws_vpc_endpoint.s3.id
          }
        }
      },
    ]
  })
}

resource "aws_s3_bucket" "s3buck" {
  bucket = "dz152-270921"
  acl    = "private"
  versioning {
    enabled = false
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykms.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = { Name = "Bucket" }
}

resource "aws_s3_bucket_object" "pic" {
  bucket = aws_s3_bucket.s3buck.id
  acl    = "private"
  key    = "pic.gif"
  source = "media/pic.gif"
}

resource "aws_kms_key" "mykms" {
  description             = "KMS key 1"
  deletion_window_in_days = 7
}



//resource "aws_s3_bucket_public_access_block" "s3allow" {
//  bucket = aws_s3_bucket.s3buck.id
//  block_public_acls   = false
//  block_public_policy = false
//}

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


//
//resource "aws_route53_resolver_endpoint" "dns_ep_in" {
//  name               = "dns_ep_in"
//  direction          = "INBOUND"
//  security_group_ids = [aws_security_group.main.id]
//
//  ip_address {
//    subnet_id = aws_subnet.private_subnet.id
//  }
//  ip_address {
//    subnet_id = aws_subnet.public_subnet.id
//  }
//
//}
//
//resource "aws_route53_resolver_endpoint" "dns_ep_out" {
//  name               = "dns_ep_out"
//  direction          = "OUTBOUND"
//  security_group_ids = [aws_security_group.main.id]
//
//  ip_address {
//    subnet_id = aws_subnet.private_subnet.id
//    ip = "172.31.96.12"
//  }
//  ip_address {
//    subnet_id = aws_subnet.public_subnet.id
//  }
//
//}
//
////resource "aws_route53_resolver_rule" "fwd_in" {
////  domain_name          = "www.dns-dz152-270921.com"
////  name                 = "dz152-270921"
////  rule_type            = "FORWARD"
////  resolver_endpoint_id = aws_route53_resolver_endpoint.dns_ep_in.id
////  target_ip {
////    ip = "172.31.96.12"
////  }
////}
//
//resource "aws_route53_resolver_rule" "fwd_out" {
//  domain_name          = "www.dns-dz152-270921.com"
//  name                 = "dz152-270921"
//  rule_type            = "FORWARD"
//  resolver_endpoint_id = aws_route53_resolver_endpoint.dns_ep_out.id
//  target_ip {
//    ip = "172.31.96.12"
//  }
//}
//
////resource "aws_route53_resolver_rule_association" "rt53_fin" {
////  resolver_rule_id = aws_route53_resolver_rule.fwd_in.id
////  vpc_id           = aws_vpc.my_vpc.id
////}
//
//resource "aws_route53_resolver_rule_association" "rt53_fout" {
//  resolver_rule_id = aws_route53_resolver_rule.fwd_out.id
//  vpc_id           = aws_vpc.my_vpc.id
//}

resource "aws_elb" "my_elb" {
  name  = "my-elb"
  subnets = [aws_subnet.private_subnet.id]
  internal = true


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
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true

  //vpc_zone_identifier  = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id, aws_subnet.public_subnet3.id]
  vpc_zone_identifier  = [aws_subnet.private_subnet.id]

  load_balancers = [aws_elb.my_elb.id]

  lifecycle {
    create_before_destroy = true
  }
}

