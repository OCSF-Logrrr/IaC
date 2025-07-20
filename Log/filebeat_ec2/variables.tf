#variables.tf

###########################################################################################
########################################## VPC ############################################
###########################################################################################

variable "vpc_cidr" {
  type = string
  default = "20.0.0.0/16"
  description = "VPC CIDR"
}

###########################################################################################
####################################### Subnet ############################################
###########################################################################################

variable "public_subnet_cidr" {
  type = string
  default = "20.0.1.0/24"
  description = "Public subnet CIDR"
}

variable "availability_zone" {
  type = string
  default = "ap-northeast-2a"
  description = "Availability Zone for the public subnet"
}

###########################################################################################
########################################## Key ##############################################
###########################################################################################

variable "key_name" {
  type = string
  description = "Name of the key pair to use for SSH access"
  default = "whs_ocsf_logrrr"
}

###########################################################################################
########################################## SQS ##############################################
###########################################################################################

variable "cloudtrail_sqs_queue_arn" {
  type = string
  description = "SQS queue ARN for receiving CloudTrail events"
}

variable "guardduty_sqs_queue_arn" {
  type = string
  description = "SQS queue ARN for receiving GuardDuty events"
}

variable "vpc_flow_sqs_queue_arn" {
  type = string
  description = "SQS queue ARN for receiving VPC Flow events"
}

variable "cloudtrail_sqs_queue_url" {
  type = string
  description = "SQS queue URL for receiving CloudTrail events"
}

variable "guardduty_sqs_queue_url" {
  type = string
  description = "SQS queue URL for receiving GuardDuty events"
}

variable "vpc_flow_sqs_queue_url" {
  type = string
  description = "SQS queue URL for receiving VPC Flow events"
}
###########################################################################################
########################################## S3 ##############################################
###########################################################################################

variable "cloudtrail_s3_bucket_arn" {
  type = string
  description = "S3 bucket ARN for CloudTrail logs"
}

variable "cloudtrail_s3_bucket_id" {
  type = string
  description = "S3 bucket ID for CloudTrail logs"
}

variable "guardduty_s3_bucket_arn" {
  type = string
  description = "S3 bucket ARN for GuardDuty findings"
}

variable "guardduty_s3_bucket_id" {
  type = string
  description = "S3 bucket ID for GuardDuty findings"
}

variable "vpc_flow_log_s3_bucket_arn" {
  type = string
  description = "S3 bucket ARN for VPC Flow Logs"
}

variable "vpc_flow_log_s3_bucket_id" {
  type = string
  description = "S3 bucket ID for VPC Flow Logs"
}