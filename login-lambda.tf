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

resource "aws_cloudwatch_log_group" "login" {
  name = "/aws/lambda/${aws_lambda_function.login.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "login" {
  function_name = "login"

  s3_bucket = aws_s3_bucket.login_bucket.id
  s3_key    = aws_s3_object.lambda_login.key

  runtime = "nodejs18.x"
  handler = "handler.login"

  source_code_hash = data.archive_file.login.output_base64sha256
  role = "arn:aws:iam::968379224811:role/LabRole"
}