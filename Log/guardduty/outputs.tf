#outputs.tf

output "guardduty_detector_id" {
  description = "생성된 GuardDuty 탐지기의 ID"
  value       = aws_guardduty_detector.main.id
}

output "guardduty_publishing_destination_id" {
  description = "GuardDuty 결과 저장 설정 리소스의 ID"
  value       = aws_guardduty_publishing_destination.main.id
}

output "guardduty_s3_bucket_id" {
  description = "GuardDuty 결과가 저장되는 S3 버킷 이름"
  value       = var.s3_bucket_id
}

output "guardduty_s3_bucket_arn" {
  description = "GuardDuty 결과가 저장되는 S3 버킷 ARN"
  value       = var.s3_bucket_arn
}

output "guardduty_kms_key_arn" {
  description = "GuardDuty 결과 저장에 사용된 KMS 키의 ARN"
  value       = aws_kms_key.guardduty.arn
}
