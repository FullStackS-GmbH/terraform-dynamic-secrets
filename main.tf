provider "vault" {
  address         = var.vault_address
  token           = var.vault_token
  skip_tls_verify = true
}

resource "vault_aws_secret_backend" "aws_secret" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  path       = "aws"

  # Default Lease Time für dyamisches Secret (= Standard Lebensdauer)
  default_lease_ttl_seconds = "60"

  # Max Lease Time für dyamisches Secret (= Maximale Lebensdauer)
  max_lease_ttl_seconds = "120"
}

resource "vault_aws_secret_backend_role" "ec2_admin_role" {
  backend         = vault_aws_secret_backend.aws_secret.path
  name            = "ec2-admin-role"
  credential_type = "iam_user"

  # IAM Role mit Vollzugriff auf EC2 
  policy_document = <<IAM
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": ["*"]
    }
  ]
}
IAM
}


# DevOps ist richtig cool, wenn man's richtig macht :-) 


# resource "vault_aws_secret_backend_role" "s3_admin_role" {
#   backend         = vault_aws_secret_backend.aws_secret.path
#   name            = "s3-admin-role"
#   credential_type = "iam_user"

#   # IAM Role mit Vollzugriff auf S3
#   policy_document = <<IAM
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "Stmt1426528957000",
#       "Effect": "Allow",
#       "Action": ["s3:*"],
#       "Resource": ["*"]
#     }
#   ]
# }
# IAM
# }