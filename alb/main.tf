terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

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
# resource "aws_lb_target_group" "web" {
#   name        = "${var.project_name}-ecs-web"
#   port        = "80"
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     protocol            = "HTTP"
#     path                = "/"
#     matcher             = 200
#     healthy_threshold   = 10
#     unhealthy_threshold = 10
#     interval            = 300 # in seconds
#     timeout             = 120 # in seconds
#   }
# }

# # target group - app
# resource "aws_lb_target_group" "app" {
#   name        = "${var.project_name}-ecs-app"
#   port        = "80"
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     protocol            = "HTTP"
#     path                = "/"
#     matcher             = 200
#     healthy_threshold   = 10
#     unhealthy_threshold = 10
#     interval            = 300 # in seconds
#     timeout             = 120 # in seconds
#   }
# }