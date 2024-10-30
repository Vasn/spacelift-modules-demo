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

module "gateway" {
  source = "../../"

  vpc_id = aws_vpc.main.id
  nat_gateway_public_subnet_1a_id = aws_subnet.main["public-subnet-1a"].id
  nat_gateway_public_subnet_1b_id = aws_subnet.main["public-subnet-1b"].id
}

variable "aws_region" {
  type        = string
  description = "AWS region used for test"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "subnets" {
  description = "Map of subnet objects to be created"
}