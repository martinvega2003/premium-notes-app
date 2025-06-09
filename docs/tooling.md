# Tooling & Services

This document lists the main tools and AWS services used in the Premium Notes App, along with their purpose and rationale.

## 1. Version Control

- **Git & GitHub**  
  - **Purpose:** Source code management, branching strategy, pull request workflow.  
  - **Why:** Industry standard; integrates seamlessly with GitHub Actions for CI/CD.

## 2. Containerization

- **Docker**  
  - **Purpose:** Build reproducible, isolated images for frontend and backend.  
  - **Why:** Ensures “it works on my machine” consistency across environments.

- **docker-compose**  
  - **Purpose:** Orchestrate multi-container local development (API, Postgres, React).  
  - **Why:** Simplifies running and testing all services locally with a single command.

## 3. Infrastructure as Code

- **Terraform**  
  - **Purpose:** Define and provision AWS resources (VPC, RDS, ECR, ECS, S3, IAM, ALB).  
  - **Why:** Enables versioned, repeatable infrastructure; makes environment setup automated and auditable.

## 4. Cloud Orchestration

- **Amazon ECS (Fargate)**  
  - **Purpose:** Host containerized services without managing servers.  
  - **Why:** Serverless container runtime with pay-per-use billing; simpler than managing Kubernetes.

## 5. Container Registry

- **Amazon ECR**  
  - **Purpose:** Store and version Docker images for backend and frontend.  
  - **Why:** Fully managed, private registry integrated with ECS and IAM.

## 6. CI/CD

- **GitHub Actions**  
  - **Purpose:** Automate linting, testing, Docker builds, Terraform plan/apply, and deployments.  
  - **Why:** Native to GitHub; easy to configure; avoids introducing an external CI system.

## 7. Monitoring & Logging

- **Amazon CloudWatch Logs & Container Insights**  
  - **Purpose:** Collect application logs, container metrics (CPU, memory, latency).  
  - **Why:** Provides visibility into production behavior; triggers alerts on anomalies.

## 8. Secrets Management

- **AWS Secrets Manager** (or **Parameter Store**)  
  - **Purpose:** Securely store and rotate sensitive data (DB passwords, Stripe keys, JWT secret).  
  - **Why:** Keeps secrets out of code and environment files; integrates with ECS IAM roles.
