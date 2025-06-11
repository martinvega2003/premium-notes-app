# Terraform IaC Plan

This document describes the structure, variables and resources we will define in Terraform to provision our AWS infrastructure.

## 1. Terraform Folder Structure

Under `infra/terraform/` we will have:

```
infra/
└── terraform/
    ├── providers.tf
    ├── variables.tf
    ├── main.tf
    └── outputs.tf
```


## 2. Variables & Naming Conventions

- **Prefix**: All resource names will start with `devopsjunior-`.
- **Tags**: Apply a common `default_tags` map on every resource:
  - `Project = "PremiumNotesApp"`
  - `Environment = var.environment` (`dev`, `staging`, `prod`)
  - `Owner = "martin.vega"`
  - `CostCenter = "PERN-Demo"`

### Key Variables to Declare

```hcl
# variables.tf
variable "environment" { description = "Deployment environment" type = string default = "dev" }
variable "aws_region"   { description = "AWS region" type = string default = "us-east-1" }
variable "vpc_cidr"     { description = "VPC CIDR block" type = string default = "10.0.0.0/16" }
variable "public_subnets"  { description = "Public subnet CIDRs"  type = list(string) default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnets" { description = "Private subnet CIDRs" type = list(string) default = ["10.0.101.0/24","10.0.102.0/24"] }
variable "db_instance_class" { description = "RDS instance type" type = string default = "db.t3.micro" }
variable "db_name"          { description = "Postgres DB name"   type = string default = "notesdb" }
variable "db_username"      { description = "Postgres username"  type = string default = "postgres" }
variable "db_password"      { description = "Postgres password"  type = string sensitive = true }
variable "ecr_backend_name" { description = "ECR repo for backend"  type = string default = "premium-notes-backend" }
variable "ecr_frontend_name"{ description = "ECR repo for frontend" type = string default = "premium-notes-frontend" }
variable "s3_bucket_static" { description = "S3 bucket for static"  type = string default = "devopsjunior-static-frontend" }
variable "s3_bucket_attachments"{ description = "S3 bucket for attachments" type = string default = "devopsjunior-note-attachments" }
variable "default_tags" { description = "Common tags for all resources" type = map(string) default = {
  Project     = "PremiumNotesApp"
  Environment = "dev"
  Owner       = "martin.vega"
  CostCenter  = "PERN-Demo"
}}
