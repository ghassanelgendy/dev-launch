resource "aws_ecr_repository" "app" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "staging"
    Project     = "DevLaunch"
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
