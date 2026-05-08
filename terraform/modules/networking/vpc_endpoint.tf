# ── DynamoDB VPC Gateway Endpoint ────────────────────────────────────────────
# Gateway endpoints are free and route DynamoDB traffic privately
# without going through the NAT Gateway
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name        = "${var.environment}-dynamodb-endpoint"
    Environment = var.environment
  }
}
