//resource "aws_s3_bucket_policy" "terraform_s3_policy" {
//count = local.web_instance_count[terraform.workspace]
//
//policy = <<POLICY
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Effect": "Allow",
//            "Action": "s3:ListBucket",
//            "Resource": "arn:aws:s3:::buck-net-states"
//
//       },
//       {
//          "Effect": "Allow",
//          "Action": ["s3:GetObject", "s3:PutObject"],
//          "Resource": "arn:aws:s3:::buck-net-states/main-infra/terraform.tfstate"
//       },
//       {
//          "Effect": "Allow",
//          "Action": [
//          "dynamodb:GetItem",
//          "dynamodb:PutItem",
//          "dynamodb:DeleteItem"
//      ],
//          "Resource": "arn:aws:dynamodb:*:*:terraform_locks/db_terraform_locks"
//    }
//    ]
//}
//POLICY
//  bucket = "buck-net-states"
//}