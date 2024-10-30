resource "aws_route_table" "public_subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_subnet" {
  for_each = var.nat_gateways_ids

  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value
  }

  tags = {
    Name = "${each.key}-route-table"
  }
}

# resource "aws_route_table" "private_subnet_1a" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = var.nat_gateway_a_id
#   }

#   tags = {
#     Name = "app-1a-route-table"
#   }
# }

# resource "aws_route_table" "private_subnet_1b" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = var.nat_gateway_b_id
#   }

#   tags = {
#     Name = "app-1b-route-table"
#   }
# }

resource "aws_route_table" "private_data_subnet" {
  vpc_id = var.vpc_id

  tags = {
    Name = "data-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.public_subnet.id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.private_subnet[each.value.route_table_key].id
}

resource "aws_route_table_association" "data" {
  for_each = var.data_subnets

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.private_data_subnet.id
}

# resource "aws_route_table_association" "public_subnet_1a" {
#   subnet_id      = var.public_subnet_1a_id
#   route_table_id = aws_route_table.public_subnet.id
# }

# resource "aws_route_table_association" "public_subnet_1b" {
#   subnet_id      = var.public_subnet_1b_id
#   route_table_id = aws_route_table.public_subnet.id
# }

# resource "aws_route_table_association" "web_subnet" {
#   subnet_id      = var.web_subnet_1a_id
#   route_table_id = aws_route_table.private_subnet_1a.id
# }

# resource "aws_route_table_association" "app_subnet_1a" {
#   subnet_id      = var.app_subnet_1a_id
#   route_table_id = aws_route_table.private_subnet_1a.id
# }

# resource "aws_route_table_association" "app_subnet_1b" {
#   subnet_id      = var.app_subnet_1b_id
#   route_table_id = aws_route_table.private_subnet_1b.id
# }

# resource "aws_route_table_association" "data_subnet_1a" {
#   subnet_id      = var.data_subnet_1a_id
#   route_table_id = aws_route_table.private_data_subnet.id
# }

# resource "aws_route_table_association" "data_subnet_1b" {
#   subnet_id      = var.data_subnet_1b_id
#   route_table_id = aws_route_table.private_data_subnet.id
# }