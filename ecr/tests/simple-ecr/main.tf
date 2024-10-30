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

module "ecr" {
  source = "../../"

  project_name = var.project_name
  ecrs         = var.ecrs
}

variable "aws_region" {
  type        = string
  description = "AWS region used for test"
}

variable "ecrs" {
  type        = map(string)
  description = "Map of ECR details"
}

variable "project_name" {
  type        = string
  description = "Name of this project"
}