resource "aws_iam_policy" "full_access_policy" {
  name        = "FullAccessPolicy"
  description = "A policy that grants full access to the specified S3 bucket, DynamoDB table, and ECR repository."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:*",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "dynamodb:*",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "ecr:*",
        Resource = "*"
      }
    ]
  })
}
