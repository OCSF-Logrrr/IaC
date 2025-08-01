#variables.tf

###########################################################################################
########################################## VPC ###########################################
###########################################################################################

# 전체 VPC의 CIDR 블록
variable "vpc_cidr" {
  type        = string
  default     = "20.0.0.0/16"
  description = "CIDR block for the VPC"
}

###########################################################################################
####################################### Subnet ###########################################
###########################################################################################

# 퍼블릭 서브넷의 CIDR 블록
variable "public_subnet_cidr" {
  type        = string
  default     = "20.0.1.0/24"
  description = "CIDR block for the public subnet"
}

# 퍼블릭 서브넷이 배치될 가용 영역
variable "availability_zone" {
  type        = string
  default     = "ap-northeast-2a"
  description = "Availability Zone for the public subnet"
}

###########################################################################################
########################################## SSH Key #######################################
###########################################################################################

# EC2 인스턴스 접속에 사용할 키페어 이름
variable "key_name" {
  type        = string
  default     = "whs_ocsf_logrrr"
  description = "Name of the key pair to use for SSH access"
}

###########################################################################################
########################################## SQS ###########################################
###########################################################################################

# CloudTrail 이벤트를 수신하는 SQS 큐 ARN (IAM 정책에 사용)
variable "cloudtrail_sqs_queue_arn" {
  type        = string
  description = "ARN of the SQS queue receiving CloudTrail events"
}

# GuardDuty 이벤트를 수신하는 SQS 큐 ARN
variable "guardduty_sqs_queue_arn" {
  type        = string
  description = "ARN of the SQS queue receiving GuardDuty events"
}

# VPC Flow 로그를 수신하는 SQS 큐 ARN
variable "vpc_flow_sqs_queue_arn" {
  type        = string
  description = "ARN of the SQS queue receiving VPC Flow logs"
}

# CloudTrail 이벤트용 SQS 큐 URL (Filebeat 설정에서 사용)
variable "cloudtrail_sqs_queue_url" {
  type        = string
  description = "URL of the SQS queue receiving CloudTrail events"
}

# GuardDuty 이벤트용 SQS 큐 URL
variable "guardduty_sqs_queue_url" {
  type        = string
  description = "URL of the SQS queue receiving GuardDuty events"
}

# VPC Flow 로그용 SQS 큐 URL
variable "vpc_flow_sqs_queue_url" {
  type        = string
  description = "URL of the SQS queue receiving VPC Flow logs"
}

###########################################################################################
########################################## S3 ###########################################
###########################################################################################

# CloudTrail 로그가 저장될 S3 버킷 ARN (IAM 정책에 사용)
variable "cloudtrail_s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket storing CloudTrail logs"
}

# CloudTrail 로그 S3 버킷 ID (리소스 ID 또는 이름)
variable "cloudtrail_s3_bucket_id" {
  type        = string
  description = "ID of the S3 bucket storing CloudTrail logs"
}

# GuardDuty 결과 저장용 S3 버킷 ARN
variable "guardduty_s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket storing GuardDuty findings"
}

# GuardDuty 결과 S3 버킷 ID
variable "guardduty_s3_bucket_id" {
  type        = string
  description = "ID of the S3 bucket storing GuardDuty findings"
}

# VPC Flow 로그 저장용 S3 버킷 ARN
variable "vpc_flow_log_s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket storing VPC Flow logs"
}

# VPC Flow 로그 S3 버킷 ID
variable "vpc_flow_log_s3_bucket_id" {
  type        = string
  description = "ID of the S3 bucket storing VPC Flow logs"
}
