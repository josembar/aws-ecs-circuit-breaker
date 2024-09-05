resource "aws_alb" "this" {
  name               = "${local.app_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.this.ids

  enable_deletion_protection = false

  tags = {
    Name = "${local.app_prefix}-alb"
  }
}

resource "aws_alb_target_group" "this" {
  name        = "${local.app_prefix}-tg"
  port        = local.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.this.id
  health_check {
    path    = "/${local.app_path}"
    matcher = "200,304"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = local.app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}