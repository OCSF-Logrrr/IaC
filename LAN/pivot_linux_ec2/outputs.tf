#outputs.tf

output "pivot_server_security_group_id" { 
  value       = aws_security_group.pivot_server_sg.id
  description = "Pivot Server Security group ID"
}

output "pivot_ec2_instance_id" {
  value       = aws_instance.pivot_server_instance.id
  description = "Pivot Server Instance id"
}

# output "pivot_ec2_public_ip" {
#   value       = aws_eip.pivot_server_eip.public_ip
#   description = "Public IP"
# }

output "pivot_ec2_public_dns" {
  value       = aws_instance.pivot_server_instance.public_dns
  description = "Public DNS"
}

# output "pivot_eip_ec2_association" {
#   value       = aws_eip.pivot_server_eip.id
#   description = "EIP EC2 Association"
# }