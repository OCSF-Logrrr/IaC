#variables.tf

variable "project_name" {
  type        = string
  default     = "WHS-Logrrr"
  description = "Project name"
}

variable "git_repo_name" {
  type        = string
  default     = "CICD_PHP_Code"
  description = "git_repo_name"
}

variable "git_owner" {
  type        = string
  default     = "Pandyo"
  description = "git_owner"
}

variable "github_oauth_token" {
  type        = string
  default     = ""
  description = "github_oauth_token"
}

###########################################################################################
######################################### module ##########################################
###########################################################################################

variable "codebuild_name" {
  type        = string
  description = "codebuild_name"
}