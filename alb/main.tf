# load balancer
resource "aws_lb" "main" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  security_groups            = var.alb_security_groups
  subnets                    = var.alb_subnets

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# target group - web
resource "aws_lb_target_group" "web" {
  name        = "${var.project_name}-ecs-web"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = 200
    healthy_threshold   = 10
    unhealthy_threshold = 10
    interval            = 30 # in seconds
    timeout             = 10 # in seconds
  }
}

# # target group - app
resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-ecs-app"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    matcher             = 200
    healthy_threshold   = 10
    unhealthy_threshold = 10
    interval            = 30 # in seconds
    timeout             = 10 # in seconds
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener_rule" "frontend_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  condition {
    host_header {
      values = ["frontend.${aws_lb.main.dns_name}"]
    }
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["backend.${aws_lb.main.dns_name}"]
    }
  }
}
