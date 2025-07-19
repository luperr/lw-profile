provider "aws" {
  region  = "ap-southeast-4"
  profile = "admin-prod"
}

module "s3Dev" {
  source = "./modules/s3Bucket"

  env                     = "dev"
  bucket_name             = "dev-lw-profile"
  s3BucketAcl             = "public-read"
  force_destroy           = "true"
  index_document_key      = "index.html"
  error_document_key      = "error.html"
  s3BucketOwnership       = "BucketOwnerPreferred"
  s3BucketPolicyName      = "dev-lw-profile-s3BucketPolicy"
  blockPublicACLs         = "false"
  blockPublicPolicy       = "false"
  ignorePublicACLs        = "false"
  restrictPublicBuckets   = "false"
}

module "s3Prod" {
  source = "./modules/s3Bucket"

  env                     = "prod"
  bucket_name             = "prod-lw-profile"
  s3BucketAcl             = "public-read"
  force_destroy           = "true"
  index_document_key      = "index.html"
  error_document_key      = "error.html"
  s3BucketOwnership       = "BucketOwnerPreferred"
  s3BucketPolicyName      = "prod-lw-profile-s3BucketPolicy"
}