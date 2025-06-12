# Monitoring & Alerting Plan

This document describes the CloudWatch dashboards, metrics, and alarms we will configure for the Premium Notes App.

## 1. Dashboards

### 1.1 Application Overview Dashboard
- **Widgets**:
  - **Average Latency** (ALB Target Group)
    - Metric: `TargetResponseTime`
    - Period: 1 minute
    - Statistic: Average
  - **HTTP 5xx Error Rate** (ALB)
    - Expression: `HTTPCode_Target_5XX_Count / RequestCount * 100`
    - Period: 1 minute
    - Statistic: Sum
  - **ECS Container CPU Utilization**
    - Metric: `CPUUtilization` per service
    - Period: 1 minute
    - Statistic: Average
  - **ECS Container Memory Utilization**
    - Metric: `MemoryUtilization` per service
    - Period: 1 minute
    - Statistic: Average
  - **RDS CPU Utilization**
    - Metric: `CPUUtilization` for the RDS instance
    - Period: 5 minutes
    - Statistic: Average

## 2. Logs

- Centralize `stdout` and `stderr` from all containers into **CloudWatch Logs**
  - **Log Groups**:
    - `/ecs/premium-notes-backend`
    - `/ecs/premium-notes-frontend`
  - **Retention**: 7 days (adjustable)
  - **Optional**: Subscription filters to forward logs to analysis or SIEM tools

## 3. Alarms

| Alarm Name                         | Metric                       | Threshold             | Period     | Evaluation Periods | Notification Action     |
|------------------------------------|------------------------------|-----------------------|------------|--------------------|-------------------------|
| **High HTTP 5xx Error Rate**       | ALB 5XX error rate           | > 5%                  | 1 minute   | 3                  | SNS topic `alerts`      |
| **High Container CPU Utilization** | ECS `CPUUtilization`         | > 80%                 | 1 minute   | 5                  | SNS topic `alerts`      |
| **High Container Memory Utilization** | ECS `MemoryUtilization`    | > 80%                 | 1 minute   | 5                  | SNS topic `alerts`      |
| **RDS CPU High**                   | RDS `CPUUtilization`         | > 70%                 | 5 minutes  | 2                  | SNS topic `alerts`      |
| **RDS Low Free Storage**           | RDS `FreeStorageSpace`       | < 20% of allocated    | 5 minutes  | 1                  | SNS topic `alerts`      |

> **Notes:**
> - All alarms publish to an SNS topic named `alerts`, subscribed to by email or Slack.
> - Evaluation periods help avoid false positives from brief spikes.
> - Adjust thresholds and log retention after trial runs in staging.
