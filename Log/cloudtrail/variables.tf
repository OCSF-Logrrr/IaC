#variables.tf

variable "s3_bucket_id" {
    type  = string
    description = "CloudTrail 로그를 저장할 S3 버킷의 ID"
}

variable "s3_bucket_arn" {
    type  = string
    description = "CloudTrail 로그를 저장할 S3 버킷의 ARN"
}
