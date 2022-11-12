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

  tags = {
    Name        = "dynamodb-table-${var.region}-${var.workspace}-${random_uuid.name.result}"
    Environment = "${var.workspace}"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }
}
