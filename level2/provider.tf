terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "terraform-remote-state-mern-stack"
    key            = "level2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-remote-state-mern-stack"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
