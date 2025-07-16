#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr-staff"
  description = "Project name"
}

###########################################################################################
############################### Pivot Server EC2 ##########################################
###########################################################################################

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "private_subnet_id_01" {
  type        = string
  description = "private_subnet_id_01"
}

variable "key_name" {
  type        = string
  default     = "whs_ocsf_logrrr"
  description = "key_name"
}
