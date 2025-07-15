#outputs.tf

# VPC FLOW LOG 버킷 output
output "vpc_flow_log_bucket_id" {
  value       = aws_s3_bucket.vpc_flow_log_bucket.id
  description = "VPC Flow Log S3 버킷의 ID"
}

output "vpc_flow_log_bucket_arn" {
  value       = aws_s3_bucket.vpc_flow_log_bucket.arn
  description = "VPC Flow Log S3 버킷의 ARN"
}

# AWS GUARD DUTY 버킷 output
output "guardduty_result_bucket_id" {
  value       = aws_s3_bucket.guardduty_result_bucket.id
  description = "GuardDuty 결과 저장 S3 버킷의 ID"
}

output "guardduty_result_bucket_arn" {
  value       = aws_s3_bucket.guardduty_result_bucket.arn
  description = "GuardDuty 결과 저장 S3 버킷의 ARN"
}

# AWS CLOUDTRAIL 버킷 output
output "cloudtrail_log_bucket_id" {
  value       = aws_s3_bucket.cloudtrail_log_bucket.id
  description = "CloudTrail 로그 S3 버킷의 ID"
}

output "cloudtrail_log_bucket_arn" {
  value       = aws_s3_bucket.cloudtrail_log_bucket.arn
  description = "CloudTrail 로그 S3 버킷의 ARN"
}
