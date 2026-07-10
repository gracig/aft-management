terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Uncomment after bootstrapping the S3 backend (cicdlab-aws-platform/bootstrap/)
  # backend "s3" {
  #   bucket         = "cicdlab-tfstate-141971524659"
  #   key            = "aft-management/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "cicdlab-tfstate-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
}
