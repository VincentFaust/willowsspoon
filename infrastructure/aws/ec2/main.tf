terraform {
  backend "s3" {
    bucket         = "ec2-boostrap-airbyte-tf-state"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ec2-terraform-state-locking"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}
provider "aws" {
  region  = "us-east-2"
  profile = "Vincent"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "ec2-boostrap-airbyte-tf-state"
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "ec2-terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
