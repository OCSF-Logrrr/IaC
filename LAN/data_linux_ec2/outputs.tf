#outputs.tf

output "data_server_security_group_id" { 
  value       = aws_security_group.data_server_sg.id
  description = "Data Server Security group ID"
}

output "data_ec2_instance_id" {
  value       = aws_instance.data_server_instance.id
  description = "Data Server Instance id"
}

output "data_ec2_public_ip" {
  value       = aws_eip.data_server_eip.public_ip
  description = "Public IP"
}

output "data_ec2_public_dns" {
  value       = aws_instance.data_server_instance.public_dns
  description = "Public DNS"
}

# output "data_eip_ec2_association" {
#   value       = aws_eip.data_server_eip.id
#   description = "EIP EC2 Association"
# }