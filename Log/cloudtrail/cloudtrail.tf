#cloudtrail.tf

resource "aws_cloudtrail" "main" {
  depends_on                    = [aws_s3_bucket_policy.cloudtrail_log_bucket]
  name                          = "logrrr-cloudtrail"
  s3_bucket_name                = var.s3_bucket_id
  #s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cloudtrail" {
  # GetBucketAcl (버킷 자체에만)
  statement {
    sid = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [var.s3_bucket_arn]  # 버킷 ARN (예: arn:aws:s3:::logrrr-cloudtrail-log-bucket)
  }

  # PutObject (객체 경로 전체)
  statement {
    sid = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${var.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

  # ***여기 반드시 추가!***
  condition {
    test     = "StringEquals"
    variable = "s3:x-amz-acl"
    values   = ["bucket-owner-full-control"]
    }
  }
}


resource "aws_s3_bucket_policy" "cloudtrail_log_bucket" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.cloudtrail.json
}




