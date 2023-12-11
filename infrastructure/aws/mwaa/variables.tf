variable "name" {
  description = "MWAA Environment"
  default     = "mwaa-dev-environment"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR for MWAA"
  type        = string
  default     = "10.1.0.0/16"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "mwaa-bucket-0001"
}
