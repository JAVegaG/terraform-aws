resource "aws_lambda_function" "write_lambda" { #Create - Update - Delete

  filename      = "foo.zip"
  function_name = "http-write-${var.region}-${var.workspace}-${random_uuid.name.result}"
  role          = aws_iam_role.lambda_iam_write_dynamodb.arn
  handler       = "index.hanlder"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("foo.zip")

  runtime = "nodejs16.x"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }

}

resource "aws_lambda_function" "read_lambda" {

  filename      = "foo.zip"
  function_name = "http-read-${var.region}-${var.workspace}-${random_uuid.name.result}"
  role          = aws_iam_role.lambda_iam_read_dynamodb.arn
  handler       = "index.hanlder"

  source_code_hash = filebase64sha256("foo.zip")

  runtime = "nodejs16.x"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }

}
