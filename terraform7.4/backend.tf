

resource "aws_s3_bucket" "b" {
  bucket = "buck-net-states"
  acl    = "private"
}

//resource "aws_dynamodb_table" "terraform_locks" {
//    name = "db_terraform_locks"
//    //billing_mode = "PAY_PER_REQUEST"
//    hash_key = "LockID"
//
//    attribute {
//        name = "LockID"
//        type = "S"
//    }
//}
//
//terraform {
//  backend "s3" {
//    bucket         = "buck-net-states"
//    key            = "main-infra/terraform.tfstate"
//    region         = "eu-central-1"
//    dynamodb_table = "db_terraform_locks"
//
//  }
//}