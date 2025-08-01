#outputs.tf

###########################################################################################
########################################## VPC ############################################
###########################################################################################

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "vpc_arn" {
  value       = aws_vpc.vpc.arn
  description = "VPC ARN"
}

output "vpc_dns_support" {
  value       = aws_vpc.vpc.enable_dns_support
  description = "Whether or not the VPC has DNS support"
}

output "vpc_dns_hostnames" {
  value       = aws_vpc.vpc.enable_dns_hostnames
  description = "Whether or not the VPC has DNS hostname support"
}

###########################################################################################
####################################### Subnet ############################################
###########################################################################################

output "public_subnet_id_01" { 
  value       = aws_subnet.public_subnet_01.id
  description = "Public Subnet ID-01"
}

output "public_subnet_arn_01" { 
  value       = aws_subnet.public_subnet_01.arn
  description = "Public Subnet ARN-01"
}

output "private_subnet_id_01" { 
  value       = aws_subnet.private_subnet_01.id
  description = "Private Subnet ID-01"
}

output "private_subnet_arn_01" { 
  value       = aws_subnet.private_subnet_01.arn
  description = "Private Subnet ARN-01"
}

output "private_subnet_id_02" { 
  value       = aws_subnet.private_subnet_02.id
  description = "Private Subnet ID-02"
}

output "private_subnet_arn_02" { 
  value       = aws_subnet.private_subnet_02.arn
  description = "Private Subnet ARN-02"
}

output "private_subnet_id_03" { 
  value       = aws_subnet.private_subnet_03.id
  description = "Private Subnet ID-03"
}

output "private_subnet_arn_03" { 
  value       = aws_subnet.private_subnet_03.arn
  description = "Private Subnet ARN-03"
}

###########################################################################################
######################################## IGW ##############################################
###########################################################################################

output "internet_gateway_id" { 
  value       = aws_internet_gateway.internet_gateway.id
  description = "Internet Gateway ID"
}

output "internet_gateway_arn" { 
  value       = aws_internet_gateway.internet_gateway.arn
  description = "Internet Gateway ARN"
}

###########################################################################################
####################################### Route #############################################
###########################################################################################

output "public_subnet_route_table_id" { 
  value       = aws_route_table.route_table.id
  description = "Public Subnet Route table ID"
}

output "public_subnet_route_table_arn" { 
  value       = aws_route_table.route_table.arn
  description = "Public Subnet Route table ARN"
}

output "private_subnet_route_table_id" { 
  value       = aws_route_table.private_route_table.id
  description = "Private Subnet Route table ID"
}

output "private_subnet_route_table_arn" { 
  value       = aws_route_table.private_route_table.arn
  description = "Private Subnet Route table ARN"
}

###########################################################################################
#################################### NAT Instance #########################################
###########################################################################################

output "eip_id" { 
  value       = aws_eip.natinstance_eip.id
  description = "EIP ID"
}

output "nat_instance_id" {
  value = aws_instance.nat_instance.id
  description = "NAT instance ID"
}
