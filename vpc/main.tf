terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  # profile = var.aws_profile_name

  # default_tags {
  #   tags = {
  #     app_name = "${var.project_name}-app"
  #     cloud    = "aws"
  #     version  = "1.0.0"
  #     owner    = var.project_owner
  #   }
  # }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}