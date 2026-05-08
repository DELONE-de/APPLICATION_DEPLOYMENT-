# ── CloudWatch Log Group ──────────────────────────────────────────────────────
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.environment}-app"
  retention_in_days = var.log_retention_days

  tags = { Environment = var.environment }
}

# ── SNS Topic for Alarms ──────────────────────────────────────────────────────
resource "aws_sns_topic" "alarms" {
  name = "${var.environment}-alarms"
  tags = { Environment = var.environment }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# ── ECS CPU Alarm ─────────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.environment}-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "ECS CPU utilization above ${var.cpu_alarm_threshold}%"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = { Environment = var.environment }
}

# ── ECS Memory Alarm ──────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.environment}-ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = var.memory_alarm_threshold
  alarm_description   = "ECS memory utilization above ${var.memory_alarm_threshold}%"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = { Environment = var.environment }
}

# ── ALB 5XX Alarm ─────────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.environment}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "ALB 5XX errors above threshold"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = { Environment = var.environment }
}

# ── ALB Response Time Alarm ───────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "alb_response_time" {
  alarm_name          = "${var.environment}-alb-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "ALB target response time above 2 seconds"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = { Environment = var.environment }
}

# ── CloudWatch Dashboard ──────────────────────────────────────────────────────
resource "aws_cloudwatch_dashboard" "app" {
  dashboard_name = "${var.environment}-app"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title       = "ECS CPU Utilization"
          region      = var.aws_region
          annotations = {}
          metrics     = [["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]]
          period      = 60
          stat        = "Average"
        }
      },
      {
        type = "metric"
        properties = {
          title       = "ECS Memory Utilization"
          region      = var.aws_region
          annotations = {}
          metrics     = [["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]]
          period      = 60
          stat        = "Average"
        }
      },
      {
        type = "metric"
        properties = {
          title       = "ALB 5XX Errors"
          region      = var.aws_region
          annotations = {}
          metrics     = [["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix]]
          period      = 60
          stat        = "Sum"
        }
      },
      {
        type = "metric"
        properties = {
          title       = "ALB Response Time"
          region      = var.aws_region
          annotations = {}
          metrics     = [["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix]]
          period      = 60
          stat        = "Average"
        }
      },
      {
        type = "log"
        properties = {
          title  = "Application Logs"
          query  = "SOURCE '${aws_cloudwatch_log_group.app.name}' | fields @timestamp, @message | sort @timestamp desc | limit 50"
          region = var.aws_region
          view   = "table"
        }
      }
    ]
  })
}
