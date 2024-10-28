terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = var.aws_region
}

module "subnet" {
  source = "../../"

  vpc_id  = aws_vpc.main.id
  subnets = var.subnets
}

variable "aws_region" {
  type        = string
  description = "AWS region used for test"
}

variable "subnets" {
  description = "Map of subnet objects to be created"
}