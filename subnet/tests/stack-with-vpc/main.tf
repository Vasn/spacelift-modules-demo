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
  cidr_block = "10.1.0.0/24"
}

module "subnet" {
  source = "../../"

  vpc_id = aws_vpc.main.id
  subnets = {
    "public-subnet-1a" = {
      "cidr_block"              = "10.0.0.0/28",
      "availability_zone"       = "ap-southeast-1a",
      "map_public_ip_on_launch" = true,
      "name"                    = "public-subnet-a",
      "tier"                    = "public"
    },
    "public-subnet-1b" = {
      "cidr_block"              = "10.0.0.16/28",
      "availability_zone"       = "ap-southeast-1b",
      "map_public_ip_on_launch" = true,
      "name"                    = "public-subnet-b",
      "tier"                    = "public"
    },
    "app-subnet-1a" = {
      "cidr_block"              = "10.0.0.48/28",
      "availability_zone"       = "ap-southeast-1a",
      "map_public_ip_on_launch" = false,
      "name"                    = "app-subnet-a",
      "tier"                    = "private"
    },
    "app-subnet-1b" = {
      "cidr_block"              = "10.0.0.64/28",
      "availability_zone"       = "ap-southeast-1b",
      "map_public_ip_on_launch" = false,
      "name"                    = "app-subnet-b",
      "tier"                    = "private"
    }
  }
}