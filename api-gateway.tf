resource "aws_api_gateway_resource" "login_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.api-gateway.id
  parent_id   = data.aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_method" "login_post_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.login_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_model" "MyDemoModel" {
  rest_api_id  = data.aws_api_gateway_rest_api.api-gateway.id
  name         = "user"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = jsonencode({
    type = "object"
  })
}

resource "aws_api_gateway_integration" "login_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.api-gateway.id
  resource_id             = aws_api_gateway_resource.login_resource.id
  http_method             = aws_api_gateway_method.login_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  timeout_milliseconds    = 29000
  uri                     = aws_lambda_function.login.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
  "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_deployment" "api-gateway-deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.api-gateway.id

  triggers = {
    redeployment = sha1(jsonencode([
      data.aws_api_gateway_rest_api.api-gateway.id,
      aws_api_gateway_method.login_post_method.id,
      aws_api_gateway_integration.login_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api-gateway-deployment-stage" {
  deployment_id = aws_api_gateway_deployment.api-gateway-deployment.id
  rest_api_id   = data.aws_api_gateway_rest_api.api-gateway.id
  stage_name    = "dev"
}
