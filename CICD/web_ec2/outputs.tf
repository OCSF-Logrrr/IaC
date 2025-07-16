#outputs.tf

###########################################################################################
############################### Web Server EC2 ############################################
###########################################################################################

output "web_server_security_group_id" { 
  value       = aws_security_group.web_server_sg.id
  description = "Web Server Security group ID"
}

output "web_ec2_instance_id" {
  value       = aws_instance.web_server_instance.id
  description = "Web Server Instance id"
}

output "web_ec2_public_ip" {
  value       = aws_eip.web_server_eip.public_ip
  description = "Public IP"
}

output "web_ec2_public_dns" {
  value       = aws_instance.web_server_instance.public_dns
  description = "Public DNS"
}

output "web_eip_ec2_association" {
  value       = aws_eip.web_server_eip.id
  description = "EIP EC2 Association"
}