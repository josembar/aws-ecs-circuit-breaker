output "ecr_repositories" {
  value = { for key, repo in aws_ecr_repository.this : key =>
    { name = repo.name, arn = repo.arn, url = repo.repository_url }
  }
  description = "ECR repositories"
  depends_on  = [aws_ecr_repository.this]
}
