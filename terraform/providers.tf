terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # --- Remote state (Part 1 requirement) ---
  # Bucket already exists in eu-west-1. The `key` path keeps this project separate
  # from other Terraform state objects in the same bucket.
  backend "s3" {
    bucket = "techbleat-terraform-state-438168600096"
    key    = "class20/terraform.tfstate"
    region = "eu-west-1"

    # Optional but recommended: create a DynamoDB table named "terraform-locks"
    # with partition key "LockID" (String), then uncomment the next line:
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
