terraform {

  backend "s3" {
    bucket         = "ecs-tf-state-001"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ecs-terraform-state-locking-001"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22"
    }
  }
}

provider "aws" {
  profile = "Vincent"
  region  = "us-east-2"
}


resource "aws_s3_bucket" "terraform_state" {
  bucket        = "ecs-tf-state-001"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "ecs-terraform-state-locking-001"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
