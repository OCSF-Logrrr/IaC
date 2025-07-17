#outputs.tf

# 생성된 SQS 큐의 이름 출력
output "s3_event_queue_name" {
  description = "S3 이벤트를 수신하는 SQS 큐의 이름"
  value       = aws_sqs_queue.s3_event_queue.name
}

# 생성된 SQS 큐의 URL 출력 (Filebeat 등에서 사용)
output "s3_event_queue_url" {
  description = "S3 이벤트를 수신하는 SQS 큐의 URL"
  value       = aws_sqs_queue.s3_event_queue.id
}

# 생성된 SQS 큐의 ARN 출력 (정책, 연동 설정 시 사용)
output "s3_event_queue_arn" {
  description = "S3 이벤트를 수신하는 SQS 큐의 ARN"
  value       = aws_sqs_queue.s3_event_queue.arn
}
