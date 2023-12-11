data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

locals {
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  bucket_name = var.bucket_name
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

}
