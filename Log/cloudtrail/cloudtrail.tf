#cloudtrail.tf

resource "aws_cloudtrail" "main" {
  depends_on = [aws_s3_bucket_policy.cloudtrail_log_bucket]

  name                          = "logrrr-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_log_bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    # CloudTrail에 S3 버킷에 로그를 저장하기 전, 버킷의 권한을 확인하는 것
    # S3 버킷에 로그 파일을 올릴 수 있다는 것
    actions   = [
      "s3:GetBucketAcl", 
      "s3:PutObject"
      ]
    
    # CloudTrail이 로그를 저장할 S3 경로 (AWSLogs/계정 ID 이하 전체)
    resources = [
      "${aws_s3_bucket.cloudtrail_log_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      ]
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_log_bucket" {
  bucket = aws_s3_bucket.cloudtrail_log_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

data "aws_caller_identity" "current" {}


