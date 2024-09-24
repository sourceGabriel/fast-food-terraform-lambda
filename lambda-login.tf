resource "aws_lambda_function" "login" {
  function_name = "login"

  s3_bucket = aws_s3_bucket.login_bucket.id
  s3_key    = aws_s3_object.lambda_login.key

  runtime = "nodejs18.x"
  handler = "login.login"

  source_code_hash = data.archive_file.login.output_base64sha256
  role = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
}

resource "aws_cloudwatch_log_group" "login" {
  name = "/aws/lambda/${aws_lambda_function.login.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "login" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${data.aws_api_gateway_rest_api.api-gateway.id}/*/${aws_api_gateway_method.login_post_method.http_method}${aws_api_gateway_resource.login_resource.path}"
}
