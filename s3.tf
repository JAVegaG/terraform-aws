resource "aws_s3_bucket" "s3_bucket_website" {
  bucket = "website-bucket-${var.region}-${terraform.workspace}-${random_id.name.dec}"
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_bucket_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_website_configuration" "s3-website-settings" {
#   bucket = aws_s3_bucket.s3_bucket_website.bucket

#   index_document {
#     suffix = "index.html"
#   }
# }

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.s3_bucket_website.id
  policy = data.aws_iam_policy_document.cloudfront_s3_access.json
}


