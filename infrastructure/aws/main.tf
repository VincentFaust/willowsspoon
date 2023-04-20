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
  ami           = "ami-0103f211a154d64a6"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.ws_key_pair.id
  subnet_id     = aws_subnet.main.id

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

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.vpc_set.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
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


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_set.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc_set.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_eip" "eip_integration" {
  instance = aws_instance.ws_airbyte_production.id
  vpc      = true
}
