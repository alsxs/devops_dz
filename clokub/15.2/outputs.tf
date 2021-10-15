output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.id
}

//output "ip_pub" {
//  value = aws_eip.ip_priv.public_ip
//}

output "file" {
  value = data.aws_s3_bucket_object.img.key
}

output "url" {
  value = data.aws_s3_bucket.s3buck.bucket_domain_name
}

output "elb_dns" {
  value = aws_elb.my_elb.dns_name
}

//output "aws_rt_priv"  {
//  value = aws_route_table.rt_priv
//}

//output "id" {
//  value = aws_route53_resolver_endpoint.dns_ep_out.id
//}
//
//output "arn" {
//  value = aws_route53_resolver_endpoint.dns_ep_out.arn
//}
//
//output "host_vpc_id" {
//  value = aws_route53_resolver_endpoint.dns_ep_out.host_vpc_id
//}
//
//output "id_in" {
//  value = aws_route53_resolver_endpoint.dns_ep_in.id
//}
//
//output "arn_in" {
//  value = aws_route53_resolver_endpoint.dns_ep_in.arn
//}
//
//output "host_vpc_id_in" {
//  value = aws_route53_resolver_endpoint.dns_ep_in.host_vpc_id
//}