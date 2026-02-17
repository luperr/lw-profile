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

data "aws_iam_policy_document" "cloudflare_access" {
  statement {
    sid     = "AllowCloudflareGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = ["${aws_s3_bucket.s3Bucket.arn}/*"]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cloudflare_ips
    }
  }
}

resource "aws_s3_bucket_policy" "s3BucketPolicy" {
  bucket = aws_s3_bucket.s3Bucket.id
  policy = data.aws_iam_policy_document.cloudflare_access.json
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