variable "region" {
  description = "Value of the aws region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "workspace" {
  description = "Value of the workspace that the infrastructure will be deployed to"
  type        = string
  default     = "develop"
}
