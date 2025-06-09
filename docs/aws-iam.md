# AWS IAM Setup

This document records the IAM configuration for our `devops-junior` user.

- **User ARN:** arn:aws:iam::847179581003:user/devops-junior
- **Attached Policies:**
  - AmazonEC2ContainerRegistryFullAccess
  - AmazonECS_FullAccess
  - AmazonRDSFullAccess
  - AmazonS3FullAccess
  - CloudWatchLogsFullAccess

> **Notes:**
> - This user is used by GitHub Actions and local CLI to provision infra and deploy containers.
> - No permissions to manage IAM itself, billing, or other AWS services.
