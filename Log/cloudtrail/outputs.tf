#outputs.tf

output "cloudtrail_name" {
    description = "생성된 CloudTrail의 이름"
    value = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
    description = "CloudTrail의 ARN (리소스 고유 식별자)"
    value = aws_cloudtrail.main.arn
}

output "cloudtrail_s3_bucket_name" {
    description = "CloudTrail 로그가 저장되는 S3 버킷의 이름"
    value = var.s3_bucket_id
}

output "cloudtrail_s3_bucket_arn" {
    description = "CloudTrail 로그가 저장되는 S3 버킷의 ARN"
    value = var.s3_bucket_arn
}

output "aws_account_id" {
  description = "현재 Terraform을 실행 중인 AWS 계정 ID"
  value = data.aws_caller_identity.current.account_id
}