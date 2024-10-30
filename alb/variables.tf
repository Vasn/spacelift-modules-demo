variable "project_name" {
  type = string
}

variable "alb_security_groups" {
  type = list(string)
}

variable "alb_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}