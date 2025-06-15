terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
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

# it would be nice if some of these below could be looked up, 
# but sadly this block doesn't support variables
# TODO replace bucket and kms_key_id below with your own values
terraform {
  backend "s3" {
    bucket         = "your-own-persistent-state-bucket-name"
    key            = "cloud101/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    kms_key_id     = "alias/your-own-kms-key-alias-name"
    use_lockfile = true
  }
}
