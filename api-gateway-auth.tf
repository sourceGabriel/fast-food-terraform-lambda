resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.api-gateway.id
  parent_id   = data.aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "auth"
}

resource "aws_api_gateway_method" "auth_post_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_resource.auth_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_model" "auth_model" {
  rest_api_id  = data.aws_api_gateway_rest_api.api-gateway.id
  name         = "auth"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = jsonencode({
    type = "object"
  })
}

resource "aws_api_gateway_integration" "auth_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.api-gateway.id
  resource_id             = aws_api_gateway_resource.auth_resource.id
  http_method             = aws_api_gateway_method.auth_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  timeout_milliseconds    = 29000
  uri                     = aws_lambda_function.auth.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
  "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_deployment" "auth-deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.api-gateway.id

  triggers = {
    redeployment = sha1(jsonencode([
      data.aws_api_gateway_rest_api.api-gateway.id,
      aws_api_gateway_method.auth_post_method.id,
      aws_api_gateway_integration.auth_integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "auth-deployment-stage" {
  deployment_id = aws_api_gateway_deployment.auth-deployment.id
  rest_api_id   = data.aws_api_gateway_rest_api.api-gateway.id
  stage_name    = "dev-auth"
}