resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.workspace == "main" ? "${var.table-name}" : "${var.table-name}-${var.workspace}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  hash_key = "id" #partition key

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-${var.region}-${var.workspace}-${random_id.name.id}"
    Environment = "${var.workspace}"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }
}
