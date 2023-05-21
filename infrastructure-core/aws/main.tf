#EC2 instance hosting airbyte infrastructure 

terraform {
  backend "local" {
    path = "terraform.tfstate"
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
  key_name   = "ws-airbyte"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "security_set" {
  name        = "Free Allowance"
  description = "Allow inbound SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["70.113.40.46/32"]

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
