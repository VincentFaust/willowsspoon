data "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id = data.aws_secretsmanager_secret.my_secret.id
}

data "aws_secretsmanager_secret" "my_secret" {
  name = "DBT_ENV_SECRET_PASSWORD"
}

resource "aws_s3_bucket" "this" {
  bucket = "secret-env-bucket-0001"
}

resource "aws_s3_object" "env_file" {
  bucket  = aws_s3_bucket.this.id
  key     = ".env"
  content = "PASSWORD=${data.aws_secretsmanager_secret_version.my_secret_version.secret_string}"
}
