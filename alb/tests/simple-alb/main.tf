terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id                              = aws_vpc.main.id
  cidr_block                          = each.value.cidr_block
  availability_zone                   = each.value.availability_zone
  private_dns_hostname_type_on_launch = "ip-name"
  map_public_ip_on_launch             = each.value.map_public_ip_on_launch

  tags = {
    Name = each.value.name
    Tier = each.value.tier
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow access to HTTP/HTTPS traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

module "alb" {
  source = "../../"

  project_name = var.project_name
  vpc_id       = aws_vpc.main.id
  alb_security_groups = [
    aws_security_group.alb_sg.id
  ]
  alb_subnets = [
    aws_subnet.main["public-subnet-1a"].id,
    aws_subnet.main["public-subnet-1b"].id
  ]
}

variable "aws_region" {
  type        = string
  description = "AWS region used for test"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "subnets" {
  description = "Map of subnet objects to be created"
}