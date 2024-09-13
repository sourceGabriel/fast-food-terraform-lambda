data "archive_file" "login" {
  type = "zip"

  source_dir  = "${path.module}/login"
  output_path = "${path.module}/login.zip"
}

data "aws_apigatewayv2_apis" "api-gateway" {  
  name          = "fiap-fast-food-api-gateway"
  protocol_type = "HTTP"
}

data "aws_apigatewayv2_api" "api-gateway" {
  api_id = tolist(data.aws_apigatewayv2_apis.api-gateway.ids)[0]
}