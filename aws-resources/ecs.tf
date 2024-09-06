resource "aws_ecs_cluster" "this" {
  name       = "${local.app_prefix}-cluster"
  depends_on = [aws_ecr_repository.this, terraform_data.build]
}

# resource "aws_ecs_task_definition" "this" {
#   family                   = "${local.app_prefix}-task"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = 1024
#   memory                   = 3072
#   execution_role_arn       = aws_iam_role.this.arn
#   task_role_arn            = aws_iam_role.this.arn
#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "X86_64"
#   }
#   container_definitions = jsonencode([
#     {
#       name      = local.demo_app_image_name
#       image     = "${aws_ecr_repository.this.repository_url}:${local.demo_app_image_name}-${local.image_tag}"
#       essential = true
#       portMappings = [
#         {
#           containerPort = local.app_port
#           hostPort      = local.app_port
#           protocol      = "tcp"
#           appProtocol   = "http"
#         }
#       ]
#       environment = [
#         {
#           name  = "OTEL_EXPORTER_OTLP_METRICS_ENDPOINT",
#           value = "http://localhost:4318/v1/metrics"
#         },
#         {
#           name  = "OTEL_EXPORTER_OTLP_METRICS_PROTOCOL",
#           value = "http/protobuf"
#         },
#         {
#           name  = "OTEL_SERVICE_NAME",
#           value = upper(local.demo_app_image_name)
#         }
#       ],
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-create-group"  = "true"
#           "awslogs-group"         = "/ecs/${local.app_prefix}-task"
#           "awslogs-region"        = "${data.aws_region.current.name}"
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#     },
#     {
#       name      = local.otel_image_name
#       image     = "${aws_ecr_repository.this.repository_url}:${local.otel_image_name}-${local.image_tag}"
#       essential = true
#       command = [
#         "--config=/etc/otelcol/otel-config-aws.yaml"
#       ],
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-create-group"  = "true"
#           "awslogs-group"         = "/ecs/${local.app_prefix}-task"
#           "awslogs-region"        = "${data.aws_region.current.name}"
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#     },
#     {
#       name      = local.thanos_receiver_image_name
#       image     = "${aws_ecr_repository.this.repository_url}:${local.thanos_receiver_image_name}-${local.image_tag}"
#       essential = true
#       command = [
#         "receive",
#         "--remote-write.address=0.0.0.0:10908",
#         "--label=thanos=\"true\"",
#         "--objstore.config-file=/bucket.yaml"
#       ],
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-create-group"  = "true"
#           "awslogs-group"         = "/ecs/${local.app_prefix}-task"
#           "awslogs-region"        = "${data.aws_region.current.name}"
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#     }
#   ])
#   depends_on = [
#     aws_ecs_cluster.this,
#     terraform_data.build
#   ]
#   lifecycle {
#     replace_triggered_by = [terraform_data.build.id]
#   }
# }

# resource "aws_ecs_service" "this" {
#   name            = "${local.app_prefix}-service"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.this.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   load_balancer {
#     target_group_arn = aws_alb_target_group.this.arn
#     container_name   = local.demo_app_image_name
#     container_port   = local.app_port
#   }

#   network_configuration {
#     subnets          = data.aws_subnets.this.ids
#     security_groups  = [aws_security_group.ecs.id]
#     assign_public_ip = true
#   }
# }