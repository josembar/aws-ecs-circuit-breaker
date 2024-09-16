output "ecr_repositories" {
  value = { for key, repo in aws_ecr_repository.this : key =>
    { name = repo.name, arn = repo.arn, url = repo.repository_url }
  }
  description = "ECR repositories"
  depends_on  = [aws_ecr_repository.this]
}

output "app_url" {
  value       = "http://${aws_alb.this.dns_name}:${local.app_port}/${local.app_path}"
  description = "The URL to access app"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "The name of ECS cluster"
}
