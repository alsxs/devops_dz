resource "aws_ec2_client_vpn_network_association" "vpn_priv_sub" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.vpn_sg.id]
}

resource "aws_acm_certificate" "vpn_cert_serv" {
  private_key = file("cert/server.key")
  certificate_body = file("cert/server.crt")
  certificate_chain = file("cert/ca.crt")
}

resource "aws_acm_certificate" "vpn_cert_client" {
  private_key = file("cert/client1.domain.tld.key")
  certificate_body = file("cert/client1.domain.tld.crt")
  certificate_chain = file("cert/ca.crt")
}


resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "vpn-test"
  server_certificate_arn = aws_acm_certificate.vpn_cert_serv.arn
  split_tunnel = true
  client_cidr_block      = "10.0.0.0/22"
//  dns_servers = [
//    //"172.31.96.12",
//    //"205.251.198.0",
//    //"205.251.194.0",
//    //"205.251.192.0",
//    //"172.31.96.248",
//  ]



  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_cert_client.arn
  }
  connection_log_options {
    enabled               = false
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = aws_subnet.private_subnet.cidr_block
  authorize_all_groups   = true
}

//resource "aws_ec2_client_vpn_route" "example_vpn_rt" {
//  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
//  destination_cidr_block = "0.0.0.0/0"
//  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.vpn_priv_sub.subnet_id
//}

resource "aws_security_group" "vpn_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name = "vpn-sg"

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "IncVPN"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//resource "dns_ns_record_set" "www" {
//  zone = "example.com."
//  name = "www"
//  nameservers = [
//    "a.iana-servers.net.",
//    "b.iana-servers.net.",
//  ]
//  ttl = 300
//}

