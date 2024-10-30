variable "vpc_id" {}
variable "internet_gateway_id" {}

variable "nat_gateways_ids" {
  type = map(string)
}

variable "public_subnets" {
  type = map(object({
    subnet_id = string
  }))
}

variable "private_subnets" {
  type = map(object({
    subnet_id       = string
    route_table_key = string
  }))
}

variable "data_subnets" {
  type = map(object({
    subnet_id = string
  }))
}

# variable "nat_gateway_a_id" {}
# variable "nat_gateway_b_id" {}

# variable "public_subnet_1a_id" {}
# variable "public_subnet_1b_id" {}
# variable "web_subnet_1a_id" {}
# variable "app_subnet_1a_id" {}
# variable "app_subnet_1b_id" {}
# variable "data_subnet_1a_id" {}
# variable "data_subnet_1b_id" {}
