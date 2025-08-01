#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr"
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "ap-northeast-2"
  description = "Project name"
}

variable "db_ec2_public_ip" {
  type        = string
  description = "db_ec2_public_ip"
}

variable "db_name" {
  type        = string
  default     = "board"
  description = "db_name"
}

variable "db_user" {
  type        = string
  default     = "root"
  description = "db_user"
}

variable "db_password" {
  type        = string
  default     = "1234"
  description = "db_password"
}

variable "git_repo_url" {
  type        = string
  default     = "https://github.com/OCSF-Logrrr/CICD-Code"
  description = "git_repo_url"
}
