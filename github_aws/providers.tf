terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}
