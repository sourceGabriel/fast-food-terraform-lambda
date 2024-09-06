data "archive_file" "login" {
  type = "zip"

  source_dir  = "${path.module}/login"
  output_path = "${path.module}/login.zip"
}

resource "aws_s3_object" "lambda_login" {
  bucket = aws_s3_bucket.login_bucket.id

  key    = "login.zip"
  source = data.archive_file.login.output_path

  etag = filemd5(data.archive_file.login.output_path)
}