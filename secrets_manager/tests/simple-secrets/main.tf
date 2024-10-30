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

module "secrets_manager" {
  source = "../../"

  project_name = var.project_name
  secret_map   = var.secret_map
}

variable "aws_region" {
  type        = string
  description = "AWS region used for test"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "secret_map" {
  type        = map(string)
  description = "Map of your secrets to be stored in key-value pairs"
}