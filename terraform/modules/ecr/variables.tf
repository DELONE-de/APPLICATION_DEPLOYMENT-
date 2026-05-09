variable "environment" {
  type = string
}

variable "repository_name" {
  type    = string
  default = "app"
}

variable "force_delete" {
  description = "Force delete the ECR repository and all images when destroying."
  type        = bool
  default     = false
}

variable "image_retention_count" {
  description = "Number of images to keep per repository"
  type        = number
  default     = 10
}
