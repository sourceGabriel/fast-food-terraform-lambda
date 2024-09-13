# Output value definitions
output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = aws_s3_bucket.login_bucket.id
}

output "function_name" {
  description = "AWS Lambda to perform login accordingly to username"
  value = aws_lambda_function.login.function_name
}

output "api-gateway-id" {
  description = "AWS API Gateway UUID"
  value = tolist(data.aws_apigatewayv2_apis.api-gateway.ids)[0]
}