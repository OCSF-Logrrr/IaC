#outputs.tf

##############################################
# Cloudtrail 이벤트를 수신하는 SQS 큐 설정
##############################################

# 생성된 SQS 큐의 이름 출력
output "cloudtrail_event_queue_name" {
  description = "CloudTrail 이벤트를 수신하는 SQS 큐의 이름"
  value       = aws_sqs_queue.cloudtrail_event_queue.name
}

# 생성된 SQS 큐의 URL 출력 (Filebeat 등에서 사용)
output "cloudtrail_event_queue_url" {
  description = "CloudTrail 이벤트를 수신하는 SQS 큐의 URL"
  value       = aws_sqs_queue.cloudtrail_event_queue.id
}

# 생성된 SQS 큐의 ARN 출력 (정책, 연동 설정 시 사용)
output "cloudtrail_event_queue_arn" {
  description = "CloudTrail 이벤트를 수신하는 SQS 큐의 ARN"
  value       = aws_sqs_queue.cloudtrail_event_queue.arn
}

##############################################
# GuardDuty 이벤트를 수신하는 SQS 큐 설정
##############################################

# 생성된 SQS 큐의 이름 출력
output "guardduty_event_queue_name" {
  description = "GuardDuty 이벤트를 수신하는 SQS 큐의 이름"
  value       = aws_sqs_queue.guardduty_event_queue.name
}

# 생성된 SQS 큐의 URL 출력 (Filebeat 등에서 사용)
output "guardduty_event_queue_url" {
  description = "GuardDuty 이벤트를 수신하는 SQS 큐의 URL"
  value       = aws_sqs_queue.guardduty_event_queue.id
}

# 생성된 SQS 큐의 ARN 출력 (정책, 연동 설정 시 사용)
output "guardduty_event_queue_arn" {
  description = "GuardDuty 이벤트를 수신하는 SQS 큐의 ARN"
  value       = aws_sqs_queue.guardduty_event_queue.arn
}

##############################################
# VPC Flow 이벤트를 수신하는 SQS 큐 설정
##############################################

# 생성된 SQS 큐의 이름 출력
output "vpc_flow_event_queue_name" {
  description = "VPC Flow 이벤트를 수신하는 SQS 큐의 이름"
  value       = aws_sqs_queue.vpc_flow_event_queue.name
}

# 생성된 SQS 큐의 URL 출력 (Filebeat 등에서 사용)
output "vpc_flow_event_queue_url" {
  description = "VPC Flow 이벤트를 수신하는 SQS 큐의 URL"
  value       = aws_sqs_queue.vpc_flow_event_queue.id
}

# 생성된 SQS 큐의 ARN 출력 (정책, 연동 설정 시 사용)
output "vpc_flow_event_queue_arn" {
  description = "VPC Flow 이벤트를 수신하는 SQS 큐의 ARN"
  value       = aws_sqs_queue.vpc_flow_event_queue.arn
}