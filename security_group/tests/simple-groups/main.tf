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

module "security_group" {
  source = "../../"

  project_name                          = var.project_name
  vpc_id =  aws_vpc.main.id
  web_port = var.web_port
  app_port = var.app_port
}

variable "aws_region" {
  type        = string
  description = "AWS region used for test"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "project_name" {
  type        = string
  description = "Name of this project"
}

variable "web_port" {
  type        = number
  description = "Container port for web container"
}

variable "app_port" {
  type        = number
  description = "Container port for app container"
}