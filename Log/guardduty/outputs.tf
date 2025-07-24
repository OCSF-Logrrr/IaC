#outputs.tf

output "guardduty_detector_id" {
  description = "생성된 GuardDuty 탐지기의 ID"
  value       = aws_guardduty_detector.main.id
}

