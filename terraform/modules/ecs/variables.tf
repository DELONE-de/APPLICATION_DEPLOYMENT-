variable "environment" {
  type = string
}

variable "app_image" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "dynamodb_table_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "task_execution_role_arn" {
  description = "From iam module output"
  type        = string
}

variable "task_role_arn" {
  description = "From iam module output"
  type        = string
}

variable "log_group_name" {
  description = "From monitoring module output"
  type        = string
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}
