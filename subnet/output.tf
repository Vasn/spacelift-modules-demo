output "public_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.main :
    key => {
      subnet_id = subnet.id
    }
    if subnet.tags["Tier"] == "public"
  }
  description = "Map of public subnet keys to their subnet IDs."
}

output "private_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.main :
    key => {
      subnet_id       = subnet.id
      route_table_key = (substr(key, length(key) - 1, 1)) == "a" ? "nat_a" : "nat_b"
    }
    if subnet.tags["Tier"] == "private"
  }
  description = "Map of private subnet keys to their subnet IDs."
}

output "data_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.main :
    key => {
      subnet_id = subnet.id
    }
    if subnet.tags["Tier"] == "private_database"
  }
  description = "Map of data public subnet keys to their subnet IDs."
}

output "subnet_cidr_blocks" {
  value       = { for subnet_name, subnet in aws_subnet.main : subnet_name => subnet.cidr_block }
  description = "Map of subnet keys to their subnet CIDR blocks."
}