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

variable "domain_name" {
  type        = string
  default     = "test.logrrrrrrr.site"
  description = "domain_name"
}

variable "nameservers" {
  type        = list(string)
  default     = ["ns", "ns2"]
  description = "NS hostname list"
}

variable "enable_reverse_zone" {
  type        = bool
  default     = true
  description = "Enable reverse DNS zone setup"
}

variable "reverse_zone_name" {
  type        = string
  default     = "37.3.in-addr.arpa"
  description = "Reverse zone name (e.g., 37.3.in-addr.arpa)"
}

variable "reverse_zone_file" {
  type        = string
  default     = "db.3.37"
  description = "Reverse zone file name (e.g., db.3.37)"
}

variable "ip_port" {
  type        = string
  default     = ""
  description = "ip_port"
}