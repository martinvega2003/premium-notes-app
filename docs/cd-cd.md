# CI/CD Pipeline Design

This document outlines our Continuous Integration (CI) and Continuous Deployment (CD) workflows using GitHub Actions.

---

## 1. CI Workflow

```yaml
name: CI

on:
  push:
    branches:
      - dev
  pull_request:
    branches:
      - dev

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # Frontend lint & test
      - name: Set up Node.js 18
        uses: actions/setup-node@v3
        with:
          node-version: 18
      - name: Install & Lint Frontend
        run: |
          cd frontend
          npm ci
          npm run lint
      - name: Test Frontend
        run: |
          cd frontend
          npm test -- --coverage

      # Backend lint & test
      - name: Install & Lint Backend
        run: |
          cd backend
          npm ci
          npm run lint
      - name: Test Backend
        run: |
          cd backend
          npm test -- --coverage

  build-images:
    runs-on: ubuntu-latest
    needs: lint-and-test
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker images
        run: |
          cd backend
          docker build -t ${{ secrets.ECR_REPOSITORY_BACKEND }}:latest .
          cd ../frontend
          docker build -t ${{ secrets.ECR_REPOSITORY_FRONTEND }}:latest .
      - name: Validate docker-compose
        run: docker-compose config
```

## 2. CD Workflow

```yaml
name: CD

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_DEFAULT_REGION }}

      - name: Login to ECR
        run: |
          aws ecr get-login-password --region ${{ secrets.AWS_DEFAULT_REGION }} \\
            | docker login --username AWS --password-stdin ${{ secrets.ECR_REGISTRY }}

      - name: Build & Push Backend Image
        run: |
          cd backend
          docker build -t ${{ secrets.ECR_REGISTRY }}/${{ secrets.ECR_REPOSITORY_BACKEND }}:latest .
          docker push ${{ secrets.ECR_REGISTRY }}/${{ secrets.ECR_REPOSITORY_BACKEND }}:latest

      - name: Build & Push Frontend Image
        run: |
          cd frontend
          docker build -t ${{ secrets.ECR_REGISTRY }}/${{ secrets.ECR_REPOSITORY_FRONTEND }}:latest .
          docker push ${{ secrets.ECR_REGISTRY }}/${{ secrets.ECR_REPOSITORY_FRONTEND }}:latest

      - name: Terraform Init & Apply
        run: |
          cd infra/terraform
          terraform init
          terraform apply -auto-approve

      - name: Update ECS Service (if needed)
        run: |
          # If Terraform doesn’t auto-update ECS, you can force a new deployment:
          aws ecs update-service \\
            --cluster premium-notes-cluster \\
            --service backend-service \\
            --force-new-deployment
```
