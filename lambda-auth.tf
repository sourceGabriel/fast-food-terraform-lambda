resource "aws_lambda_function" "auth" {
  function_name = "auth"

  s3_bucket = aws_s3_bucket.auth_bucket.id
  s3_key    = aws_s3_object.lambda_auth.key

  runtime = "nodejs18.x"
  handler = "auth.auth"

  source_code_hash = data.archive_file.auth.output_base64sha256
  role = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
}

resource "aws_cloudwatch_log_group" "auth" {
  name = "/aws/lambda/${aws_lambda_function.auth.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_permission" "auth" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${data.aws_api_gateway_rest_api.api-gateway.id}/*/${aws_api_gateway_method.auth_post_method.http_method}${aws_api_gateway_resource.auth_resource.path}"
}
