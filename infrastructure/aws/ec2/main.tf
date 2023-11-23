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

resource "aws_instance" "ws_airbyte_production" {
  ami           = "ami-0b0f111b5dcb2800f"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ws_key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.security_set.id,
  ]

  tags = {
    name        = "ws_airbyte_production"
    enviornment = "production"
  }
}

resource "aws_key_pair" "ws_key_pair" {
  key_name   = "ws-airbyte-pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "security_set" {
  name        = "ec2-security-group"
  description = "Allow inbound SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_eip" "eip_integration" {
  instance = aws_instance.ws_airbyte_production.id
  vpc      = true
}
