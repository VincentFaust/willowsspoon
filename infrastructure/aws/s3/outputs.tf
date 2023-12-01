output "snowflake_role_arn" {
  description = "The ARN of the Snowflake S3 access role"
  value       = aws_iam_role.snowflake_role.arn
}
