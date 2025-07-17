#variabes.tf

variable "project_name" {
    type  = string
    default = "Logrrr"
}

variable "cloudtrail_s3_bucket_arn" {
  description = "CloudTrail 로그가 저장되는 S3 버킷의 ARN"
  type        = string
}

variable "cloudtrail_s3_bucket_id" {
  description = "CloudTrail 로그가 저장되는 S3 버킷의 ID"
  type        = string
}

variable "guardduty_s3_bucket_arn" {
  description = "GuardDuty 결과가 저장되는 S3 버킷의 ARN"
  type        = string
}

variable "guardduty_s3_bucket_id" {
  description = "GuardDuty 결과가 저장되는 S3 버킷의 ID"
  type        = string
}

variable "vpc_flow_log_s3_bucket_arn" {
  description = "VPC Flow 로그가 저장되는 S3 버킷의 ARN"
  type        = string
}

variable "vpc_flow_log_s3_bucket_id" {
  description = "VPC Flow 로그가 저장되는 S3 버킷의 ID"
  type        = string
}
