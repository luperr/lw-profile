variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-4"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in org/repo format"
  default     = "luperr/lw-profile"
}

variable "dev_bucket_name" {
  type        = string
  description = "S3 bucket name for dev environment (must match domain)"
  default     = "dev.lachlannwhitehill.com"
}

variable "prod_bucket_name" {
  type        = string
  description = "S3 bucket name for prod environment (must match domain)"
  default     = "lachlannwhitehill.com"
}
