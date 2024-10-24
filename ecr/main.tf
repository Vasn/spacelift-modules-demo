resource "aws_ecr_repository" "main" {
  for_each = var.ecrs

  name                 = "${var.project_name}-${each.value}-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}