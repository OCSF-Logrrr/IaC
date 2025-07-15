#kms.tf

# KMS 키 생성
resource "aws_kms_key" "guardduty" {
  description             = "KMS key for Guardduty S3 publishing"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid      = "Allow GuardDuty to use the key",
        Effect   = "Allow",
        Principal = {
          Service = "guardduty.amazonaws.com"
        },
        Action   = [
          "kms:GenerateDataKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        Resource = "*"
      },
      {
        Sid: "Enable IAM User Permissions",
        Effect: "Allow",
        Principal: {
          AWS: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action: "kms:*",
        Resource: "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}