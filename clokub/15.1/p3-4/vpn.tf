resource "aws_ec2_client_vpn_network_association" "vpn_priv_sub" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = aws_subnet.private_subnet.id
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "vpn-test"
  server_certificate_arn = var.serv_sert
  split_tunnel = true
  client_cidr_block      = "10.0.0.0/16"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.sert
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
