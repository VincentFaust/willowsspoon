resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

}


resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "object1" {
  for_each = fileset("dags/", "**/*.py")
  bucket   = aws_s3_bucket.this.id
  key      = "dags/${each.value}"
  source   = "dags/${each.value}"
  etag     = filemd5("dags/${each.value}")
}

resource "aws_s3_object" "reqs" {
  for_each = fileset("dependencies/", "*")
  bucket   = aws_s3_bucket.this.id
  key      = "dependencies/${each.value}"
  source   = "dependencies/${each.value}"
  etag     = filemd5("dependencies/${each.value}")
}
