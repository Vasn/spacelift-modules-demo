resource "aws_secretsmanager_secret" "main" {
  name                    = "${var.project_name}-app-env-variables-${random_integer.number.result}"
  recovery_window_in_days = 0 # force deletion without recovery
  description             = "Environment variables for ${var.project_name}"
}

resource "random_integer" "number" {
  min = 1
  max = 100
}

resource "aws_secretsmanager_secret_version" "app_env_var" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = jsonencode(var.secret_map)
}