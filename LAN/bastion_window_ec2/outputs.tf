#outputs.tf

output "window_server_security_group_id" { 
  value       = aws_security_group.window_server_sg.id
  description = "Window Server Security group ID"
}

output "window_ec2_instance_id" {
  value       = aws_instance.window_server_instance.id
  description = "Window Server Instance id"
}

output "window_ec2_public_ip" {
  value       = aws_eip.window_server_eip.public_ip
  description = "Public IP"
}

output "window_ec2_public_dns" {
  value       = aws_instance.window_server_instance.public_dns
  description = "Public DNS"
}

output "window_eip_ec2_association" {
  value       = aws_eip.window_server_eip.id
  description = "EIP EC2 Association"
}