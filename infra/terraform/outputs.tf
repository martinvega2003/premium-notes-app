# -------------------------------------------------
# outputs.tf
# -------------------------------------------------

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

output "rds_endpoint" {
  description = "The endpoint of the PostgreSQL RDS instance"
  value       = aws_db_instance.postgres.endpoint
}

output "ecr_backend_repository_url" {
  description = "URL of the ECR repository for the backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repository_url" {
  description = "URL of the ECR repository for the frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "s3_static_bucket_name" {
  description = "Name of the S3 bucket for static frontend assets"
  value       = aws_s3_bucket.static.id
}

output "s3_attachments_bucket_name" {
  description = "Name of the S3 bucket for note attachments"
  value       = aws_s3_bucket.attachments.id
}
