# -------------------------------------------------
# variables.tf
# -------------------------------------------------

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "notesdb"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Master password for RDS (use Secrets Manager in production)"
  type        = string
  default     = "changeme"
  sensitive   = true
}

variable "ecr_backend_name" {
  description = "ECR repository name for the backend image"
  type        = string
  default     = "premium-notes-backend"
}

variable "ecr_frontend_name" {
  description = "ECR repository name for the frontend image"
  type        = string
  default     = "premium-notes-frontend"
}

variable "s3_bucket_static" {
  description = "Name of the S3 bucket for static frontend hosting"
  type        = string
  default     = "devopsjunior-static-frontend"
}

variable "s3_bucket_attachments" {
  description = "Name of the S3 bucket for note attachments"
  type        = string
  default     = "devopsjunior-note-attachments"
}

variable "default_tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "PremiumNotesApp"
    Environment = var.environment
    Owner       = "martin.vega"
    CostCenter  = "PERN-Demo"
  }
}
