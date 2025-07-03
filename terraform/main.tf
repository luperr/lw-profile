provider "aws" { }

resource "aws_s3_bucket_website_configuration" "dev-lw-profile" {
    bucket = "prod-lw-profile"

    index_document {
        suffix = "public/index.html"
    }
}

resource "aws_s3_bucket_website_configuration" "prod-lw-profile" {
    bucket = "dev-lw-profile"

    index_document {
        suffix = "public/index.html"
    }
}