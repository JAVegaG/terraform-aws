terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"

  cloud {
    organization = "applaudo-devops"

    workspaces {
      name = "aws-lambdas-api"
    }
  }

}

provider "aws" {
  region = var.region
}

resource "random_id" "name" {
  byte_length = 8
}
