terraform {
  backend "s3" {
    bucket         = "shopify-raw-tf-state"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "shopify-raw-tf-state-locking"
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

resource "aws_s3_bucket" "raw_bucket" {
  bucket        = "shopify-raw"
  force_destroy = true

}


resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.raw_bucket.id

  rule {
    id = "rule-1"

    expiration {
      days = 30
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "shopify_raw_public_access_block" {
  bucket = aws_s3_bucket.raw_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "terraform_state" {
  bucket        = "shopify-raw-tf-state"
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "shopify-raw-tf-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
