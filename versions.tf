
terraform {
  required_version = "> 0.14"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "~> 2.70.4"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}