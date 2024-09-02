terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.8.0, < 1.9.0"
}

provider "aws" {
  default_tags {
    tags = {
      App       = local.app_prefix
      CreatedBy = "Terraform"
    }
  }
}