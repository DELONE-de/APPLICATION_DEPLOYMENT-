variable "environment" {
  type = string
}

variable "repository_name" {
  type    = string
  default = "app"
}

variable "image_retention_count" {
  description = "Number of images to keep per repository"
  type        = number
  default     = 10
}
