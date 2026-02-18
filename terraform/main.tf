provider "aws" {
  region = "ap-southeast-4"
}

locals {
  cloudflare_ips = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
    "2400:cb00::/32",
    "2606:4700::/32",
    "2803:f800::/32",
    "2405:b500::/32",
    "2405:8100::/32",
    "2a06:98c0::/29",
    "2c0f:f248::/32",
  ]
}

module "s3Dev" {
  source = "./modules/s3Bucket"

  env                   = "dev"
  bucket_name           = "dev.lachlannwhitehill.com"
  s3BucketAcl           = "public-read"
  force_destroy         = "true"
  index_document_key    = "index.html"
  error_document_key    = "error.html"
  s3BucketOwnership     = "BucketOwnerPreferred"
  s3BucketPolicyName    = "dev-lw-profile-s3BucketPolicy"
  blockPublicACLs       = "false"
  blockPublicPolicy     = "false"
  ignorePublicACLs      = "false"
  restrictPublicBuckets = "false"
  cloudflare_ips        = local.cloudflare_ips
}

module "s3Prod" {
  source = "./modules/s3Bucket"

  env                   = "prod"
  bucket_name           = "lachlannwhitehill.com"
  s3BucketAcl           = "public-read"
  force_destroy         = "true"
  index_document_key    = "index.html"
  error_document_key    = "error.html"
  s3BucketOwnership     = "BucketOwnerPreferred"
  s3BucketPolicyName    = "prod-lw-profile-s3BucketPolicy"
  blockPublicACLs       = "false"
  blockPublicPolicy     = "false"
  ignorePublicACLs      = "false"
  restrictPublicBuckets = "false"
  cloudflare_ips        = local.cloudflare_ips
}

# Imports the manually created OIDC provider into Terraform state on first apply.
import {
  to = aws_iam_openid_connect_provider.github
  id = "arn:aws:iam::855402793358:oidc-provider/token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:luperr/lw-profile:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-lw-profile"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}

data "aws_iam_policy_document" "github_s3_access" {
  statement {
    sid = "SiteBucketAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [
      module.s3Dev.arn_s3_bucket,
      "${module.s3Dev.arn_s3_bucket}/*",
      module.s3Prod.arn_s3_bucket,
      "${module.s3Prod.arn_s3_bucket}/*",
    ]
  }

  statement {
    sid = "TerraformStateAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::lw-profile-terraform-state",
      "arn:aws:s3:::lw-profile-terraform-state/*",
    ]
  }
}

resource "aws_iam_role_policy" "github_s3_access" {
  name   = "github-actions-s3-access"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_s3_access.json
}
