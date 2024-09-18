resource "aws_s3_object" "lambda_auth" {
  bucket = aws_s3_bucket.auth_bucket.id

  key    = "auth.zip"
  source = data.archive_file.auth.output_path

  etag = filemd5(data.archive_file.auth.output_path)
}

resource "random_pet" "auth_bucket_name" {
  prefix = "auth-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "auth_bucket" {
  bucket = random_pet.auth_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "auth_bucket" {
  bucket = aws_s3_bucket.auth_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "auth_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.auth_bucket]
  bucket = aws_s3_bucket.auth_bucket.id
  acl    = "private"
}