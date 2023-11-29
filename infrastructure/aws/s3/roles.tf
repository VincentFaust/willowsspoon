resource "aws_iam_role" "snowflake_role" {
  name = "snowflake_s3_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          AWS = ["arn:aws:iam::791808326604:user/32ff0000-s", "arn:aws:iam::784153138185:user/vincentffaust"]
        },
        Condition = {
          StringEquals = {
            "sts:ExternalId" : "ME48922_SFCRole=2_nCCu+7CdoP1v/Y3J6zxJXzXPAnc="
          }
        }
      }
    ]
  })
}



resource "aws_iam_policy" "snowflake_access" {
  name        = "snowflake_access_policy"
  path        = "/"
  description = "Policy for Snowflake to access specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.raw_bucket.arn}",
          "${aws_s3_bucket.raw_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "snowflake_access_attachment" {
  role       = aws_iam_role.snowflake_role.name
  policy_arn = aws_iam_policy.snowflake_access.arn
}
