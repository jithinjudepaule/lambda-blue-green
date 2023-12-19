# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.1.7"
  backend "s3" {
    bucket         = "tf-backend-bucket-1988-new"
    key            = "terraform.tfstate-dev"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}

provider "aws" {
  region = var.region

}

