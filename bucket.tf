resource "aws_s3_object" "lambda_login" {
  bucket = aws_s3_bucket.login_bucket.id

  key    = "login.zip"
  source = data.archive_file.login.output_path

  etag = filemd5(data.archive_file.login.output_path)
}

resource "random_pet" "login_bucket_name" {
  prefix = "login-terraform-functions"
  length = 4
}

resource "aws_s3_bucket" "login_bucket" {
  bucket = random_pet.login_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "login_bucket" {
  bucket = aws_s3_bucket.login_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "login_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.login_bucket]
  bucket = aws_s3_bucket.login_bucket.id
  acl    = "private"
} 
