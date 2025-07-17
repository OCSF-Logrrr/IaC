#variables.tf

variable "s3_bucket_id" {
    type            =   string
    description     =   "VPC_Flow_Log 로그를 저장할 S3 버킷의 ID"
}
variable "s3_bucket_arn" {
    type            =   string
    description     =   "VPC_Flow_Log 로그를 저장할 S3 버킷의 ARN"
}
