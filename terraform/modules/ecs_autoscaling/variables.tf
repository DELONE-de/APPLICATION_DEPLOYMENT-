variable "environment" {
  type = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 4
}

variable "cpu_scale_out_threshold" {
  description = "CPU % to trigger scale out"
  type        = number
  default     = 70
}

variable "cpu_scale_in_threshold" {
  description = "CPU % to trigger scale in"
  type        = number
  default     = 30
}
