output "table_name" {
  description = "DynamoDB table name to inject into ECS task as DYNAMODB_TABLE env var"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "DynamoDB table ARN for IAM policy"
  value       = aws_dynamodb_table.this.arn
}
