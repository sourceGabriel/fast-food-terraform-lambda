resource "aws_apigatewayv2_api" "api-gateway" {
  name          = "fiap-fast-food-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "login" {
  api_id = aws_apigatewayv2_api.api-gateway.id

  integration_uri    = aws_lambda_function.login.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "login" {
  api_id = aws_apigatewayv2_api.api-gateway.id

  route_key = "GET /clientes"
  target    = "integrations/${aws_apigatewayv2_integration.login.id}"
}

resource "aws_lambda_permission" "login" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api-gateway.execution_arn}/*/*"
}