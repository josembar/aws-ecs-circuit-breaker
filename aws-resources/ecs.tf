locals {
  deploy_java_app = false
}

resource "aws_ecs_cluster" "this" {
  name       = "${local.app_prefix}-cluster"
  depends_on = [aws_ecr_repository.this, terraform_data.build]
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.app_prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 3072
  execution_role_arn       = aws_iam_role.this.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = local.app_prefix
      image     = local.deploy_java_app ? "${aws_ecr_repository.this.repository_url}:${local.java_image_name}-${local.image_tag}" : "${aws_ecr_repository.this.repository_url}:${local.nodejs_image_name}-${local.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = local.app_port
          hostPort      = local.app_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "PORT",
          value = "${local.app_port}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"         = "/ecs/${local.app_prefix}-task"
          "awslogs-region"        = "${data.aws_region.current.name}"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  depends_on = [
    aws_ecs_cluster.this,
    terraform_data.build
  ]
}

resource "aws_ecs_service" "this" {
  name            = "${local.app_prefix}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enabled  = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.arn
    container_name   = local.app_prefix
    container_port   = local.app_port
  }

  network_configuration {
    subnets          = data.aws_subnets.this.ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_policy.this]
}