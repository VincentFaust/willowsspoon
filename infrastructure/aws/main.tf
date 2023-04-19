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

resource "aws_instance" "ws_airbyte_001" {
  ami           = "ami-0103f211a154d64a6"
  instance_type = "t2.medium"
}

resource "aws_vpc" "vpc_set" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "security_set" {
  name        = "Free Allowance"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc_set.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_eip" "eip_integration" {
  instance = aws_instance.ws_airbyte_001.id
  vpc      = true
}
