terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 6.2"
		}
	}

	required_version = ">= 1.12"

	backend "s3" {
		bucket = "lw-profile-terraform-state"
		key    = "lw-profile/terraform.tfstate"
		region = "ap-southeast-4"
	}
}
