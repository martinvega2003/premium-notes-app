# infra/terraform/main.tf

# ---------------------------------------------------
# 1. Networking
# ---------------------------------------------------

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(var.public_subnets, each.value))
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(var.private_subnets, each.value))
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public Route Table & Routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Security Groups
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.environment}-ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.environment}-rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------
# 2. Database
# ---------------------------------------------------

resource "aws_db_subnet_group" "default" {
  name       = "${var.environment}-db-subnets"
  subnet_ids = values(aws_subnet.private)[*].id
}

resource "aws_db_instance" "postgres" {
  identifier              = "${var.environment}-postgres"
  engine                  = "postgres"
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  allocated_storage       = 20
  skip_final_snapshot     = true
}

# ---------------------------------------------------
# 3. ECR Repositories
# ---------------------------------------------------

resource "aws_ecr_repository" "backend" {
  name = var.ecr_backend_name
}

resource "aws_ecr_repository" "frontend" {
  name = var.ecr_frontend_name
}

# ---------------------------------------------------
# 4. ECS & Fargate (Cluster, Task Definitions & Services)
# ---------------------------------------------------

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"
}

# Task definitions and service resources will be added in next phase

# ---------------------------------------------------
# 5. Application Load Balancer
# ---------------------------------------------------

resource "aws_lb" "app" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = values(aws_subnet.public)[*].id
}

# ---------------------------------------------------
# 6. S3 Buckets
# ---------------------------------------------------

resource "aws_s3_bucket" "static" {
  bucket = var.s3_bucket_static
  acl    = "public-read"
}

resource "aws_s3_bucket" "attachments" {
  bucket = var.s3_bucket_attachments
  acl    = "private"
}
