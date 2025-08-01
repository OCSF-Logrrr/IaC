#sqs.tf

##############################################
# SQS 큐 3개 생성
##############################################

resource "aws_sqs_queue" "cloudtrail_event_queue" {
    name  = "cloudtrail-sqs" # 큐 이름 지정
}

resource "aws_sqs_queue" "guardduty_event_queue" {
    name  = "guardduty-sqs" # 큐 이름 지정
}

resource "aws_sqs_queue" "vpc_flow_event_queue" {
    name  = "vpc-flow-sqs" # 큐 이름 지정
}

##############################################
# SQS에 S3가 메시지 보낼 수 있도록 정책 부여
##############################################

# cloudtrail S3 버킷에서 SQS로 메시지를 보낼 수 있도록 허용하는 정책
data "aws_iam_policy_document" "cloudtrail_to_sqs_policy" {
  statement {
    sid     = "AllowS3ToSendMessage"
    effect  = "Allow"
    actions = ["sqs:SendMessage"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [
      aws_sqs_queue.cloudtrail_event_queue.arn
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [
        var.cloudtrail_s3_bucket_arn  # CloudTrail S3 버킷 ARN
      ]
    }
  }
}

# GuardDuty SQS 큐에 Lambda가 메시지를 받을 수 있도록 권한 부여
data "aws_iam_policy_document" "guardduty_lambda_sqs_policy" {
  statement {
    sid     = "AllowLambdaToReceiveMessage"
    effect  = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    resources = [
      "arn:aws:sqs:ap-northeast-2:317164914199:guardduty-sqs"  # GuardDuty SQS 큐 ARN
    ]
  }
}

# VPC Flow S3 버킷에서 SQS로 메시지를 보낼 수 있도록 허용하는 정책
data "aws_iam_policy_document" "vpc_flow_to_sqs_policy" {
  statement {
    sid     = "AllowS3ToSendMessage"
    effect  = "Allow"
    actions = ["sqs:SendMessage"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [
      aws_sqs_queue.vpc_flow_event_queue.arn
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [
        var.vpc_flow_log_s3_bucket_arn  # VPC Flow Logs S3 버킷 ARN
      ]
    }
  }
}

##############################################
# 위 IAM 정책을 실제 SQS 큐에 적용
##############################################

resource "aws_sqs_queue_policy" "cloudtrail_event_queue_policy" {
  queue_url = aws_sqs_queue.cloudtrail_event_queue.id
  policy    = data.aws_iam_policy_document.cloudtrail_to_sqs_policy.json
}

resource "aws_sqs_queue_policy" "guardduty_event_queue_policy" {
  queue_url = aws_sqs_queue.guardduty_event_queue.id
  policy    = data.aws_iam_policy_document.guardduty_lambda_sqs_policy.json
}

resource "aws_sqs_queue_policy" "vpc_flow_event_queue_policy" {
  queue_url = aws_sqs_queue.vpc_flow_event_queue.id
  policy    = data.aws_iam_policy_document.vpc_flow_to_sqs_policy.json
}

############################################
# CloudTrail S3 버킷에 이벤트 알림 설정
############################################

resource "aws_s3_bucket_notification" "cloudtrail_notification" {
  bucket = var.cloudtrail_s3_bucket_id  # 대상 S3 버킷 ID
  
  queue {
    queue_arn = aws_sqs_queue.cloudtrail_event_queue.arn  # 알림을 받을 SQS 큐의 ARN
    events    = ["s3:ObjectCreated:*"]  # 새 객체가 생성될 때마다 알림
  }

  depends_on = [aws_sqs_queue_policy.cloudtrail_event_queue_policy] # 정책 적용 후 알림 설정
}

############################################
# VPC Flow Logs S3 버킷에 이벤트 알림 설정
############################################

resource "aws_s3_bucket_notification" "vpc_flow_notification" {
  bucket = var.vpc_flow_log_s3_bucket_id

  queue {
    queue_arn = aws_sqs_queue.vpc_flow_event_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.vpc_flow_event_queue_policy]
}