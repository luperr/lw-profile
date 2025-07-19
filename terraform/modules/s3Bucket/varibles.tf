variable "env" {
  type = string
  description = "Environment Name"
  default = "dev"
  validation {
    condition = contains(["dev", "prod"], var.env)
    error_message = "Valid value is one of the following: dev, prod, stag, qa"
  }
}

variable "bucket_name" {
  type = string
  description = "Bucket Name"
}

variable "s3BucketAcl" {
  type = string
  description = "ACLs, Public or Private"
  default = "private"
  validation {
    condition = contains(["private", "public-read", "public-read-write", "aws-exec-read", "authenticated-read", "log-delivery-write"], var.s3BucketAcl)
    error_message = "Valid value is one of the following: dev, prod, stag, qa"
  }
}

variable "versioning" {
  type = string
  description = "Versioning status of s3 bucket"
  default = "Disabled"
  validation {
    condition = contains(["Enabled", "Suspended", "Disabled"], var.versioning)
    error_message = "Valid value is one of the following: Enabled, Suspended, Disabled"
  }
}

variable "force_destroy" {
  type = string
  description = "Permanently remove objects upon bucket deletion"
  default = "true"
  validation {
    condition = contains(["true", "false"], var.force_destroy)
    error_message = "Valid value is one of the following: true, false"
  }
}

variable "index_document_key" {
  type = string
  description = "Index key for static website hosting"
}

variable "error_document_key" {
  type = string
  description = "Error key for static website hosting"
  default = "error.html"
}

variable "s3BucketOwnership" {
  type = string
  description = "Ownership of an S3 bucket"
  default = "BucketOwnerPreferred"
  validation {
    condition = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.s3BucketOwnership)
    error_message = "Valid value is one of the following: BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced"
  }
}

variable "s3BucketPolicyName" {
  type = string
  description = "Name of S3 bucket policy"
}

variable "blockPublicACLs" {
  type = string
  description = "Select true to block public ACLs otherwise false"
  default = "true"
  validation {
    condition = contains(["true", "false"], var.blockPublicACLs)
    error_message = "Valid value is one of the following: true, false"
  }
}

variable "blockPublicPolicy" {
  type = string
  description = "Select true to block public policy otherwise false"
  default = "true"
  validation {
    condition = contains(["true", "false"], var.blockPublicPolicy)
    error_message = "Valid value is one of the following: true, false"
  }
}

variable "ignorePublicACLs" {
  type = string
  description = "Select true to ignore public ACLs otherwise false"
  default = "true"
  validation {
    condition = contains(["true", "false"], var.ignorePublicACLs)
    error_message = "Valid value is one of the following: true, false"
  }
} 

variable "restrictPublicBuckets" {
  type = string
  description = "Select true to restrict public buckets otherwise false"
  default = "true"
  validation {
    condition = contains(["true", "false"], var.restrictPublicBuckets)
    error_message = "Valid value is one of the following: true, false"
  }
}