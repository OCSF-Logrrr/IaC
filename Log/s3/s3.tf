#s3.tf

# VPC FLOW LOG 버킷
resource "aws_s3_bucket" "vpc_flow_log_bucket" {
  bucket = "${var.project_name}-vpc-flow-log-bucket"
}

# AWS GAURDDUTY 버킷
resource "aws_s3_bucket" "guardduty_result_bucket" {
  bucket = "${var.project_name}-gaurdduty-result-bucket"
}

# AWS CLOUDTRAIL 버킷
resource "aws_s3_bucket" "cloudtrail_log_bucket" {
  bucket = "${var.project_name}-cloudtrail-log-bucket"
}
