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

module "vpc" {
  source = "../../"

  vpc_cidr_block = var.vpc_cidr_block
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}