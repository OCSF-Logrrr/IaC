#guardduty.tf

# 가드듀티 생성
resource "aws_guardduty_detector" "main" {
  enable = true
}

# S3 Logs 탐지 활성화
resource "aws_guardduty_detector_feature" "s3_logs" {
  detector_id = aws_guardduty_detector.main.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

# S3 결과를 저장하기 위한 publishing Destination 리소스
resource "aws_guardduty_publishing_destination" "main" {
  detector_id     = aws_guardduty_detector.main.id
  destination_arn = var.s3_bucket_arn     # main.tf에서 module.s3.guardduty_result_bucket_arn 전달
  kms_key_arn   = aws_kms_key.guardduty.arn
}

data "aws_iam_policy_document" "guardduty_s3" {
  statement {
    sid    = "AWSGuardDutyWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["guardduty.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${var.s3_bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "guardduty_result_bucket" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.guardduty_s3.json
}


