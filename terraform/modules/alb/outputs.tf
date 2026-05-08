output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn_suffix" {
  description = "Used by monitoring module for CloudWatch dimensions"
  value       = aws_lb.this.arn_suffix
}

output "target_group_arn" {
  description = "Pass this to the ECS module"
  value       = aws_lb_target_group.app.arn
}
