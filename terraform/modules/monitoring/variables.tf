variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch dimensions"
  type        = string
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "cpu_alarm_threshold" {
  type    = number
  default = 80
}

variable "memory_alarm_threshold" {
  type    = number
  default = 80
}

variable "alarm_email" {
  type = string
}
