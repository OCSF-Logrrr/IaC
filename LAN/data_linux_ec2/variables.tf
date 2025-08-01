#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr-staff"
  description = "Project name"
}

###########################################################################################
############################### Data Server EC2 ###########################################
###########################################################################################

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "private_subnet_id_02" {
  type        = string
  description = "private_subnet_id_02"
}

variable "key_name" {
  type        = string
  default     = "whs_ocsf_logrrr"
  description = "key_name"
}
