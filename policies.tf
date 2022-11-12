resource "aws_iam_role" "lambda_iam_write_dynamodb" {
  name = "lambda_iam_write_dynamodb"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "${aws_dynamodb_table.dynamodb-table.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "lambda_iam_read_dynamodb" {
  name = "lambda_iam_read_dynamodb"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:Scan"
            ],
            "Resource": "${aws_dynamodb_table.dynamodb-table.arn}"
        }
    ]
}
EOF
}
