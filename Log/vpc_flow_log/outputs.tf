#outputs.tf

output "vpc_flow_log_id" {
    description = "생성된 vpc_flow_log의 ID"
    value = aws_flow_log.main.id
}

output "vpc_flow_log_role_arn" {
    description = "VPC Flow Log가 사용하는 IAM 역할의 ARN"
    value = aws_iam_role.vpc_flow_log_role.arn
}

output "vpc_flow_log_bucket_arn" {
  description = "VPC Flow Log 결과가 저장되는 S3 버킷 ARN"
  value       = var.s3_bucket_arn
}