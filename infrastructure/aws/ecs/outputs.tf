output "vpic_id" {
  description = "ID of the dev VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "allow_all_security_group_id" {
  description = "Security group ID for security group"
  value       = aws_security_group.allow_all.id
}
