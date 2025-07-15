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