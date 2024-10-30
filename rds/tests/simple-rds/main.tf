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

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-db-sg"
  description = "Allow access to RDS from app instance"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

module "rds" {
  source = "../../"

  project_name         = var.project_name
  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name
  db_engine_type       = var.db_engine_type
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  db_storage_type      = var.db_storage_type
  db_sg_ids = [
    aws_security_group.rds.id
  ]
  db_subnets = [
    aws_subnet.main["data-subnet-1a"].id,
    aws_subnet.main["data-subnet-1b"].id
  ]
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

variable "project_name" {
  type        = string
  description = "Name of this project"
}

variable "db_allocated_storage" {
  type        = number
  description = "The amount of allocated storage for the RDS instance (in GB)"
}

variable "db_name" {
  type        = string
  description = "Database Name"
}

variable "db_engine_type" {
  type        = string
  description = "Database Engine Type"
}

variable "db_engine_version" {
  type        = string
  description = "Database Engine Version (based on the DB type)"
}

variable "db_instance_class" {
  type        = string
  description = "RDS Instance Type e.g. db.t2.micro"
}

variable "db_username" {
  type        = string
  description = "Username for master user"
}

variable "db_password" {
  type        = string
  description = "Password for master user"
}

variable "db_storage_type" {
  type        = string
  description = "RDS Storage Type e.g. gp3"
}