provider "aws" {
  profile = var.AWS_PROFILE
  region  = var.AWS_REGION
}

terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.25.0"
    }
  }
}


