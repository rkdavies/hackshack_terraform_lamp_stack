terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ec2   = "http://localhost:4566"
    rds   = "http://localhost:4566"
    elb   = "http://localhost:4566"
    elbv2 = "http://localhost:4566"
    s3    = "http://localhost:4566"
  }
}
