resource "aws_security_group" "alb" {
  name        = "${local.app_prefix}-alb-sg"
  description = "Allow http traffic for alb"
  vpc_id      = data.aws_vpc.this.id

  tags = {
    Name = "${local.app_prefix}-alb-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs" {
  name        = "${local.app_prefix}-ecs-sg"
  description = "Allow http traffic for ecs task"
  vpc_id      = data.aws_vpc.this.id

  tags = {
    Name = "${local.app_prefix}-ecs-sg"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.alb]
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = local.app_port
  ip_protocol = "tcp"
  to_port     = local.app_port
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = local.app_port
  ip_protocol                  = "tcp"
  to_port                      = local.app_port
}

resource "aws_vpc_security_group_egress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}