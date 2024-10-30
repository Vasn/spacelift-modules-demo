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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "a" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "b" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "a" {
  allocation_id = aws_eip.a.id
  subnet_id     = aws_subnet.main["public-subnet-1a"].id
}

resource "aws_nat_gateway" "b" {
  allocation_id = aws_eip.b.id
  subnet_id     = aws_subnet.main["public-subnet-1b"].id
}

module "route_table" {
  source = "../../"

  vpc_id              = aws_vpc.main.id
  internet_gateway_id = aws_internet_gateway.igw.id
  nat_gateways_ids = {
    "nat_a" = aws_nat_gateway.a.id,
    "nat_b" = aws_nat_gateway.b.id
  }
  public_subnets = {
    for key, subnet in aws_subnet.main :
    key => {
      subnet_id = subnet.id
    }
    if subnet.tags["Tier"] == "public"
  }
  private_subnets = {
    for key, subnet in aws_subnet.main :
    key => {
      subnet_id       = subnet.id
      route_table_key = (substr(key, length(key) - 1, 1)) == "a" ? "nat_a" : "nat_b"
    }
    if subnet.tags["Tier"] == "public"
  }
  data_subnets = {
    for key, subnet in aws_subnet.main :
    key => {
      subnet_id = subnet.id
    }
    if subnet.tags["Tier"] == "private_database"
  }
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