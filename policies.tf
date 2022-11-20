resource "aws_iam_role" "lambda_iam_write_dynamodb" {
  name = "lambda_iam_write-${random_id.name.id}"

  path = "/service-role/"

  assume_role_policy = data.aws_iam_policy_document.lambdas_policy.json
  managed_policy_arns = [
    aws_iam_policy.write_db_policy.arn,
    aws_iam_policy.cloudwatch_lambda_write_policy.arn
  ]

}

resource "aws_iam_role" "lambda_iam_read_dynamodb" {
  name = "lambda_iam_read-${random_id.name.id}"

  path = "/service-role/"

  assume_role_policy = data.aws_iam_policy_document.lambdas_policy.json
  managed_policy_arns = [
    aws_iam_policy.read_db_policy.arn,
    aws_iam_policy.cloudwatch_lambda_read_policy.arn
  ]

}

# --- Lambdas ---

data "aws_iam_policy_document" "lambdas_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# --- CloudWatch ---

resource "aws_iam_policy" "cloudwatch_lambda_read_policy" {
  name = "cloudwatch-lambda-read-policy-${random_id.name.id}"

  path = "/service-role/"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "logs:CreateLogGroup",
          "Resource" : "arn:aws:logs:${var.region}:${var.account_id}:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/http-read-${var.region}-${terraform.workspace}-${random_id.name.id}:*"
          ]
        }
      ]
    }
  )

}

resource "aws_iam_policy" "cloudwatch_lambda_write_policy" {
  name = "cloudwatch-lambda-write-policy-${random_id.name.id}"

  path = "/service-role/"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "logs:CreateLogGroup",
          "Resource" : "arn:aws:logs:${var.region}:${var.account_id}:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/http-write-${var.region}-${terraform.workspace}-${random_id.name.id}:*"
          ]
        }
      ]
    }
  )

}

# --- DynamoDB ---

resource "aws_iam_policy" "read_db_policy" {
  name = "read-dynamo-policy-${random_id.name.id}"

  path = "/service-role/"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:Scan"
          ],
          "Resource" : "arn:aws:dynamodb:${var.region}:${var.account_id}:table/*"
        }
      ]
    }
  )

}

resource "aws_iam_policy" "write_db_policy" {
  name = "write-dynamo-policy-${random_id.name.id}"

  path = "/service-role/"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:DeleteItem",
            "dynamodb:PutItem",
            "dynamodb:UpdateItem"
          ],
          "Resource" : "arn:aws:dynamodb:${var.region}:${var.account_id}:table/*"
        }
      ]
    }
  )

}

# --- S3 ---

data "aws_iam_policy_document" "cloudfront_s3_access" {

  version = "2008-10-17"

  statement {
    sid     = "AllowCloudFront_s3_access"
    actions = ["s3:GetObject"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.s3_bucket_website.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.s3_distribution.arn}"]
    }
  }

}
