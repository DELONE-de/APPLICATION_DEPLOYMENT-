variable "environment" {
  type = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB to use as CloudFront origin"
  type        = string
}
