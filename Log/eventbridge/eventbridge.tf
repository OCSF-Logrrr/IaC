#eventbridge.tf

# GuardDuty 이벤트를 SQS로 전달하는 EventBridge 규칙 및 타겟

resource "aws_cloudwatch_event_rule" "guardduty_to_sqs" {
  name        = "guardduty-to-sqs-rule"
  description = "GuardDuty 탐지 이벤트를 SQS로 전달"
  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    "detail-type" = ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "sqs_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_to_sqs.name
  arn       = var.guardduty_sqs_queue_arn
}

# EventBridge가 SQS에 메시지를 넣을 수 있도록 권한 부여

resource "aws_sqs_queue_policy" "allow_eventbridge" {
  queue_url = var.guardduty_sqs_queue_url

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = [
          "sqs:SendMessage"
        ],
        Resource = [
          var.guardduty_sqs_queue_arn
        ]
      }
    ]
  })
}
