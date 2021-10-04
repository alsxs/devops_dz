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