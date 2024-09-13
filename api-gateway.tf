resource "aws_apigatewayv2_stage" "login" {
  api_id = tolist(data.aws_apigatewayv2_apis.api-gateway.ids)[0]

  name        = "development"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "login" {
  api_id = tolist(data.aws_apigatewayv2_apis.api-gateway.ids)[0]

  route_key = "POST /login"
  target    = "integrations/${aws_apigatewayv2_integration.login.id}"
}

resource "aws_apigatewayv2_integration" "login" {
  api_id = tolist(data.aws_apigatewayv2_apis.api-gateway.ids)[0]

  integration_uri    = aws_lambda_function.login.invoke_arn
  integration_type   = "HTTP"
  integration_method = "POST"
}