#main.tf

module "s3" {
  source        = "./s3"
}

# CloudTrail 
module "cloudtrail" {
  source        = "./cloudtrail"
  s3_bucket_arn = module.s3.cloudtrail_log_bucket_arn
  s3_bucket_id  = module.s3.cloudtrail_log_bucket_id
}

# Gaurdduty
module "guardduty" {
  source        = "./guardduty"
  s3_bucket_arn = module.s3.guardduty_result_bucket_arn
  s3_bucket_id  = module.s3.guardduty_result_bucket_id
}

# VPC Flow Log
module "vpc_flow_log" {
  source = "./vpc_flow_log"
  s3_bucket_arn  = module.s3.vpc_flow_log_bucket_arn
  s3_bucket_id   = module.s3.vpc_flow_log_bucket_id
}

# SQS
module "sqs"  {
  source  = "./sqs"

  cloudtrail_s3_bucket_arn = module.s3.cloudtrail_log_bucket_arn
  cloudtrail_s3_bucket_id = module.s3.cloudtrail_log_bucket_id

  guardduty_s3_bucket_arn = module.s3.guardduty_result_bucket_arn
  guardduty_s3_bucket_id = module.s3.guardduty_result_bucket_id
  
  vpc_flow_log_s3_bucket_arn = module.s3.vpc_flow_log_bucket_arn
  vpc_flow_log_s3_bucket_id = module.s3.vpc_flow_log_bucket_id
}

# Filebeat EC2
module "filebeat_ec2" {
  source = "./filebeat_ec2"
  
  cloudtrail_s3_bucket_arn = module.s3.cloudtrail_log_bucket_arn
  cloudtrail_s3_bucket_id = module.s3.cloudtrail_log_bucket_id

  guardduty_s3_bucket_arn = module.s3.guardduty_result_bucket_arn
  guardduty_s3_bucket_id = module.s3.guardduty_result_bucket_id

  vpc_flow_log_s3_bucket_arn = module.s3.vpc_flow_log_bucket_arn
  vpc_flow_log_s3_bucket_id = module.s3.vpc_flow_log_bucket_id

  cloudtrail_sqs_queue_url = module.sqs.cloudtrail_event_queue_url
  cloudtrail_sqs_queue_arn = module.sqs.cloudtrail_event_queue_arn

  guardduty_sqs_queue_url = module.sqs.guardduty_event_queue_url
  guardduty_sqs_queue_arn = module.sqs.guardduty_event_queue_arn

  vpc_flow_sqs_queue_url = module.sqs.vpc_flow_event_queue_url
  vpc_flow_sqs_queue_arn = module.sqs.vpc_flow_event_queue_arn  
}

# EventBridge
module "eventbridge" {
  source = "./eventbridge"

  guardduty_sqs_queue_url = module.sqs.guardduty_event_queue_url
  guardduty_sqs_queue_arn = module.sqs.guardduty_event_queue_arn

}

# Lambda
module "lambda" {
  source = "./lambda" 

  guardduty_sqs_queue_url = module.sqs.guardduty_event_queue_url
  guardduty_sqs_queue_arn = module.sqs.guardduty_event_queue_arn

}
