

variable "vpc_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "private_route_table_id" {
  type = string
}
