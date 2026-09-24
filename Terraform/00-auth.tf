# 00-auth.tf
# Provider service authentication and configuration


terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}