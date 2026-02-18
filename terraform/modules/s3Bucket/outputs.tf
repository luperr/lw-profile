output "s3Bucket" {
  value = aws_s3_bucket.s3Bucket
}

output "bucketversioning" {
  value = aws_s3_bucket_versioning.s3BucketVersioning
}

output "website_bucket_id" {
  value = aws_s3_bucket.s3Bucket.id
}

output "arn_s3_bucket" {
  value = aws_s3_bucket.s3Bucket.arn
}
