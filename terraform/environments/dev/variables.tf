variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "table_name" {
  type    = string
  default = "items"
}



variable "alarm_email" {
  type = string
  default = "convenati@gmail.com"
}
