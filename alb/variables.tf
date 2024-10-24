variable "project_name" {
  type = string
}

variable "alb_security_groups" {
  type = list(string)
}

variable "alb_subnets" {
  type = list(string)
}

# variable "vpc_id" {
#   type = string
# }

# variable "web_instance_port" {
#   type = number # port 3000 
# }

# variable "app_instance_port" {
#   type = number # port 8001
# }