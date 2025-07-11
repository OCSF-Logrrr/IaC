#vpc_flow_log.tf
# Flow Log 생성
resource "aws_flow_log" "main" {
  log_destination = "arn:aws:s3:::logrrr-vpc-flow-log-bucket"
  log_destination_type = "s3"
  traffic_type    = "ALL"
  vpc_id          = "vpc-09edd77bad579d171"
}


# IAM Role
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc-flow-log-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name        = "vpc-flow-log-policy"
  role        = aws_iam_role.vpc_flow_log_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        
        Resource = [
          "arn:aws:s3:::logrrr-vpc-flow-log-bucket",
          "arn:aws:s3:::logrrr-vpc-flow-log-bucket/*"
        ]
      },
    ]
  })
}
