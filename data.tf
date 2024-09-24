data "archive_file" "login" {
  type = "zip"

  source_dir  = "${path.module}/login"
  output_path = "${path.module}/login.zip"
}

data "archive_file" "auth" {
  type = "zip"

  source_dir  = "${path.module}/auth"
  output_path = "${path.module}/auth.zip"
}

data "aws_caller_identity" "current" {
  
}

data "aws_api_gateway_rest_api" "api-gateway" {
  name = "fiap-fast-food-api-gateway"
}
