resource "aws_lambda_function" "write_lambda" { #Create - Update - Delete

  filename      = "index.zip"
  function_name = "http-write-${var.region}-${terraform.workspace}-${random_id.name.id}"
  role          = aws_iam_role.lambda_iam_write_dynamodb.arn
  handler       = "index.handler"

  tracing_config {
    mode = "PassThrough"
  }

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("index.zip")

  runtime = "nodejs16.x"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }

}

resource "aws_lambda_function" "read_lambda" {

  filename      = "index.zip"
  function_name = "http-read-${var.region}-${terraform.workspace}-${random_id.name.id}"
  role          = aws_iam_role.lambda_iam_read_dynamodb.arn
  handler       = "index.handler"

  tracing_config {
    mode = "PassThrough"
  }

  source_code_hash = filebase64sha256("index.zip")

  runtime = "nodejs16.x"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }

}

resource "aws_lambda_permission" "invoke_read_lambda_all_books_Permission" {
  statement_id  = "invoke-read-lambda-all-books-${var.region}-${terraform.workspace}-${random_id.name.id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = terraform.workspace == "main" ? "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}" : "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}-${terraform.workspace}"

}

resource "aws_lambda_permission" "invoke_write_lambda_all_books_Permission" {
  statement_id  = "invoke-write-lambda-all-books-${var.region}-${terraform.workspace}-${random_id.name.id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = terraform.workspace == "main" ? "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}" : "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}-${terraform.workspace}"

}

resource "aws_lambda_permission" "invoke_read_lambda_books_id_Permission" {
  statement_id  = "invoke-read-lambda-books-id-${var.region}-${terraform.workspace}-${random_id.name.id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = terraform.workspace == "main" ? "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}/{id}" : "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}-${terraform.workspace}/{id}"

}

resource "aws_lambda_permission" "invoke_write_lambda_books_id_Permission" {
  statement_id  = "invoke-write-lambda-books-id-${var.region}-${terraform.workspace}-${random_id.name.id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = terraform.workspace == "main" ? "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}/{id}" : "${aws_apigatewayv2_api.api.execution_arn}/*/*/${var.table-name}-${terraform.workspace}/{id}"

}
