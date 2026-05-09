# ── ECR Repository ────────────────────────────────────────────────────────────
resource "aws_ecr_repository" "this" {
  name                 = "${var.environment}-${var.repository_name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "${var.environment}-${var.repository_name}"
    Environment = var.environment
  }
}

# ── Lifecycle Policy ──────────────────────────────────────────────────────────
# Keeps only the last N images, removes untagged images after 1 day
resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images after 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep last ${var.image_retention_count} images"
        selection = {
          tagStatus   = "tagged"
          tagPrefixList = ["v", "latest"]
          countType   = "imageCountMoreThan"
          countNumber = var.image_retention_count
        }
        action = { type = "expire" }
      }
    ]
  })
}
