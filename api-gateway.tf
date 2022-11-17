resource "aws_apigatewayv2_api" "api" {
  name          = "api-${var.region}-${terraform.workspace}-${random_id.name.id}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["HTTP", "HTTPS"]
    allow_headers = ["*"]
    allow_methods = ["*"]
  }

}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = terraform.workspace == "main" ? "$default" : terraform.workspace
  auto_deploy = terraform.workspace == "main" ? true : false
}

resource "aws_apigatewayv2_integration" "read_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  description            = "Lambda general read"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.read_lambda.arn
}

resource "aws_apigatewayv2_integration" "write_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type        = "INTERNET"
  description            = "Lambda general write"
  integration_method     = "POST"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.write_lambda.arn
}

resource "aws_apigatewayv2_deployment" "api_deployment" {
  api_id      = aws_apigatewayv2_api.api.id
  description = "Api deployment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      # jsonencode(aws_apigatewayv2_integration.write_integration),
      jsonencode(aws_apigatewayv2_route.general_get_route),
      jsonencode(aws_apigatewayv2_route.get_id_route),
      jsonencode(aws_apigatewayv2_route.post_route),
      jsonencode(aws_apigatewayv2_route.put_id_route),
      jsonencode(aws_apigatewayv2_route.delete_id_route)
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }

}

# --- General GET ---

resource "aws_apigatewayv2_route" "general_get_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = terraform.workspace == "main" ? "GET /${var.table-name}" : "GET /${var.table-name}-${terraform.workspace}"

  target = "integrations/${aws_apigatewayv2_integration.read_integration.id}"
}

# --- GET by id ---

resource "aws_apigatewayv2_route" "get_id_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = terraform.workspace == "main" ? "GET /${var.table-name}/{id}" : "GET /${var.table-name}-${terraform.workspace}/{id}"

  target = "integrations/${aws_apigatewayv2_integration.read_integration.id}"
}

# --- POST ---

resource "aws_apigatewayv2_route" "post_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = terraform.workspace == "main" ? "POST /${var.table-name}" : "POST /${var.table-name}-${terraform.workspace}"

  target = "integrations/${aws_apigatewayv2_integration.write_integration.id}"
}

# --- PUT by id ---

resource "aws_apigatewayv2_route" "put_id_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = terraform.workspace == "main" ? "PUT /${var.table-name}/{id}" : "PUT /${var.table-name}-${terraform.workspace}/{id}"

  target = "integrations/${aws_apigatewayv2_integration.write_integration.id}"
}

# --- DELETE by id ---

resource "aws_apigatewayv2_route" "delete_id_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = terraform.workspace == "main" ? "DELETE /${var.table-name}/{id}" : "DELETE /${var.table-name}-${terraform.workspace}/{id}"

  target = "integrations/${aws_apigatewayv2_integration.write_integration.id}"
}
