#sqs.tf

##############################################
# SQS 큐 활성화
##############################################

resource "aws_sqs_queue" "s3_event_queue" {
    name  = "${var.project_name}.s3-event-queue" # 큐 이름 지정
}

##############################################
# SQS에 S3가 메시지 보낼 수 있도록 정책 부여
##############################################

data "aws_iam_policy_document" "s3_to_sqs_policy" {
  statement {
    sid = "AllowS3TosendMessage"  # 정책 식별자
    effect = "Allow"  # 허용 정책
    actions = ["sqs:SendMessage"] # SQS에 메시지 보내는 권한
    principals {
      type  = "service" # 서비스 주체
      identifiers = ["s3.amazonaws.com"] # S3 서비스가 이 정책 대상
    }
    resources = [aws_sqs_queue.s3_event_queue.arn]  # 메시지를 받을 SQS 큐의 ARN

    condition {
      test = "ArnLike"  # 조건 : 특정 S3 버킷에서만 허용
      variable  = "aws:SourceArn" # 비교할 조건 변수
      values = [  # 허용할 S3 버킷들
        var.cloudtrail_s3_bucket_arn
        var.guardduty_s3_bucket_arn
        var.vpc_flow_log_s3_bucket_arn
      ]
    }
  }
}

##############################################
# 위 IAM 정책을 실제 SQS 큐에 적용
##############################################

resource "aws_sqs_queue_policy" "s3_event_queue_policy" {
  queue_url = aws_sqs_queue.s3_event_queue.id
  policy    = data.aws_iam_policy_document.s3_to_sqs_policy.json
}

############################################
# CloudTrail S3 버킷에 이벤트 알림 설정
############################################

resource "aws_s3_bucket_notification" "cloudtrail_notification" {
  bucket = var.cloudtrail_s3_bucket_id  # 대상 S3 버킷 ID

  queue {
    queue_arn = aws_sqs_queue.s3_event_queue.arn  # 알림을 받을 SQS 큐의 ARN
    events    = ["s3:ObjectCreated:*"]  # 새 객체가 생성될 때마다 알림
  }

  depends_on = [aws_sqs_queue_policy.s3_event_queue_policy] # 정책 적용 후 알림 설정
}

############################################
# GuardDuty S3 버킷에 이벤트 알림 설정
############################################

resource "aws_s3_bucket_notification" "guardduty_notification" {
  bucket = var.guardduty_s3_bucket_id

  queue {
    queue_arn = aws_sqs_queue.s3_event_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.s3_event_queue_policy]
}

############################################
# VPC Flow Logs S3 버킷에 이벤트 알림 설정
############################################

resource "aws_s3_bucket_notification" "vpcflow_notification" {
  bucket = var.vpc_flow_log_s3_bucket_id

  queue {
    queue_arn = aws_sqs_queue.s3_event_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sqs_queue_policy.s3_event_queue_policy]
}