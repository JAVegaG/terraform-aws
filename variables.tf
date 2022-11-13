variable "region" {
  description = "Value of the aws region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "Value of the aws account id"
  type        = number
  default     = 577247986912
}

variable "workspace" {
  description = "Value of the workspace that the infrastructure will be deployed to"
  type        = string
  default     = "develop"
}

variable "table-name" {
  description = "Name of the DynamoDB table that will be used"
  type        = string
  default     = "books"
}
