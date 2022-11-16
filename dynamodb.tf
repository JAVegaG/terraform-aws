resource "aws_dynamodb_table" "dynamodb-table" {
  name           = terraform.workspace == "main" ? "${var.table-name}" : "${var.table-name}-${terraform.workspace}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  hash_key = "id" #partition key

  attribute {
    name = "id"
    type = "N"
  }

  tags = {
    Name        = "dynamodb-table-${var.region}-${terraform.workspace}-${random_id.name.id}"
    Environment = "${terraform.workspace}"
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }
}
