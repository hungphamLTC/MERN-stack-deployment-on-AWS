terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-remote-state-mern-stack"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-remote-state-mern-stack"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
