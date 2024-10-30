aws_region = "ap-southeast-1"
vpc_cidr   = "10.1.0.0/24"
subnets = {
  "public-subnet-1a" = {
    "cidr_block"              = "10.1.0.0/28",
    "availability_zone"       = "ap-southeast-1a",
    "map_public_ip_on_launch" = true,
    "name"                    = "public-subnet-a",
    "tier"                    = "public"
  },
  "public-subnet-1b" = {
    "cidr_block"              = "10.1.0.16/28",
    "availability_zone"       = "ap-southeast-1b",
    "map_public_ip_on_launch" = true,
    "name"                    = "public-subnet-b",
    "tier"                    = "public"
  }
}