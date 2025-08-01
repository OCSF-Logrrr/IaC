#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr"
  description = "Project name"
}

###########################################################################################
########################################## VPC ############################################
###########################################################################################

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

###########################################################################################
####################################### Subnet ############################################
###########################################################################################

variable "public_subnet_cidr_01" {
  type        = string
  default     = "10.0.1.0/24"
  description = "첫 번째 퍼블릭 서브넷 CIDR"
}

variable "public_subnet_cidr_02" {
  type        = string
  default     = "10.0.2.0/24"
  description = "두 번째 퍼블릭 서브넷 CIDR"
}

variable "availability_zone_01" {
  type        = string
  default     = "ap-northeast-2a"
  description = "첫 번째 가용영역"
}

variable "availability_zone_02" {
  type        = string
  default     = "ap-northeast-2c"
  description = "두 번째 가용영역"
}