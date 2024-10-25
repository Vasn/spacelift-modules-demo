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

resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id                              = var.vpc_id
  cidr_block                          = each.value.cidr_block
  availability_zone                   = each.value.availability_zone
  private_dns_hostname_type_on_launch = "ip-name"
  map_public_ip_on_launch             = each.value.map_public_ip_on_launch

  tags = {
    Name = each.value.name
    Tier = each.value.tier
  }
}