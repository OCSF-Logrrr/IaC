#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr"
  description = "Project name"
}

###########################################################################################
############################### Web Server EC2 ############################################
###########################################################################################

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "public_subnet_id_01" {
  type        = string
  description = "public_subnet_id_01"
}

variable "key_name" {
  type        = string
  default     = "whs_ocsf_logrrr"
  description = "key_name"
}

variable "ip_port" {
  type        = string
  default     = "221.144.36.127:9092"
  description = "ip_port"
}

variable "domain_name" {
  type        = string
  default     = "logrrrrrrr.site"
  description = "domain_name"
}

variable "zone_id" {
  type        = string
  default     = "Z0507475345E5EYBCZF30"
  description = "Hosting Zone id"
}

variable "db_ec2_public_ip" {
  type        = string
  description = "db_ec2_public_ip"
}