# -------------------------------------------------
# providers.tf
# -------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "devopsjunior-terraform-state"
    key            = "infra/terraform/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "devopsjunior-lock-table"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.default_tags
  }
}

data "aws_availability_zones" "available" {}
