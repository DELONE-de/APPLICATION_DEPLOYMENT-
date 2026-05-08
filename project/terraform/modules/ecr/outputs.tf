output "repository_url" {
  description = "ECR repository URL to use as app_image in ECS module"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.this.arn
}

output "registry_id" {
  value = aws_ecr_repository.this.registry_id
}
