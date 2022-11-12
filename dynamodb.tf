resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "Books"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "id" #partition key

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "author"
    type = "S"
  }

  attribute {
    name = "description"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-${var.region}-${terraform_workspace}-${random_uuid.name.result}"
    Environment = "${terraform_workspace}"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }
}
