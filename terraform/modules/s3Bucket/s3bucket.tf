resource "aws_s3_bucket" "s3Bucket" {
  bucket              = var.bucket_name
  force_destroy       = var.force_destroy
  tags = {
      project = var.bucket_name
      env = var.env
  }
}

resource "aws_s3_bucket_ownership_controls" "s3BucketOwnership" {
  bucket = aws_s3_bucket.s3Bucket.id
  rule {
    object_ownership = var.s3BucketOwnership
  }
}

resource "aws_s3_bucket_acl" "s3BucketAcl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3BucketOwnership]

  bucket = aws_s3_bucket.s3Bucket.id
  acl    = var.s3BucketAcl
}

data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket_policy" "s3BucketPolicy" {
  bucket = aws_s3_bucket.s3Bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Allow get and put objects",
  "Statement": [
    {
      "Sid": "Allow get and put objects",
      "Effect": "Allow",
      "Principal": {
        "AWS":[
          "${local.account_id}"
        ]
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.s3Bucket.arn}/*"
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_versioning" "s3BucketVersioning" {
  bucket = aws_s3_bucket.s3Bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_website_config" {
  bucket = aws_s3_bucket.s3Bucket.id
  index_document {
    suffix = var.index_document_key
  }
  error_document {
    key = var.error_document_key
  }
}

resource "aws_s3_bucket_public_access_block" "s3BucketAccess" {
  bucket = aws_s3_bucket.s3Bucket.id
  block_public_acls       = var.blockPublicACLs
  block_public_policy     = var.blockPublicPolicy
  ignore_public_acls      = var.ignorePublicACLs
  restrict_public_buckets = var.restrictPublicBuckets
}