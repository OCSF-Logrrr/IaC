#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr"
  description = "Project name"
}


variable "alb_target_group_name" {
  type        = string
  description = "alb_target_group_name"
}