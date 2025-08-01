# variables.tf

variable "guardduty_sqs_queue_arn" {
  description = "GuardDuty 이벤트를 수신하는 SQS 큐의 ARN"
  type        = string
}

variable "guardduty_sqs_queue_url" {
  description = "GuardDuty 이벤트를 수신하는 SQS 큐의 URL"
  type        = string
} 