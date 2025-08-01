#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr"
  description = "Project name"
}

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "public_subnet_id_01" {
  type        = string
  description = "public_subnet_id_01"
}

variable "public_subnet_id_02" {
  type        = string
  description = "public_subnet_id_02"
}

variable "web_ec2_instance_id" {
  type        = string
  description = "web_ec2_instance_id"
}