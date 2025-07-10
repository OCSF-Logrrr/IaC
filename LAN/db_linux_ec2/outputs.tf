#outputs.tf

output "db_server_security_group_id" { 
  value       = aws_security_group.db_server_sg.id
  description = "DB Server Security group ID"
}

output "db_ec2_instance_id" {
  value       = aws_instance.db_server_instance.id
  description = "DB Server Instance id"
}

# output "db_ec2_public_ip" {
#   value       = aws_eip.db_server_eip.public_ip
#   description = "Public IP"
# }

output "db_ec2_public_dns" {
  value       = aws_instance.db_server_instance.public_dns
  description = "Public DNS"
}

# output "db_eip_ec2_association" {
#   value       = aws_eip.db_server_eip.id
#   description = "EIP EC2 Association"
# }