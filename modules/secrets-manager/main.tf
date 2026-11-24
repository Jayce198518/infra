resource "aws_secretsmanager_secret" "db_credentials" {
  #checkov:skip=CKV_AWS_149:Uses AWS-managed Secrets Manager encryption to avoid additional customer-managed KMS key costs.
  #checkov:skip=CKV2_AWS_57:Automatic rotation is deferred until the application and database support coordinated credential rotation.
  name                    = "/pharma/${var.env}/db-credentials"
  description             = "Database credentials for the pharma ${var.env} environment"
  recovery_window_in_days = 0

  tags = {
    Name    = "/pharma/${var.env}/db-credentials"
    Env     = var.env
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = var.db_host
  })
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  #checkov:skip=CKV_AWS_149:Uses AWS-managed Secrets Manager encryption to avoid additional customer-managed KMS key costs.
  #checkov:skip=CKV2_AWS_57:JWT signing key rotation requires an application-aware key transition strategy to avoid invalidating active tokens.
  name                    = "/pharma/${var.env}/jwt-secret"
  description             = "JWT signing secret for the pharma ${var.env} environment"
  recovery_window_in_days = 0

  tags = {
    Name    = "/pharma/${var.env}/jwt-secret"
    Env     = var.env
    Project = var.project
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id = aws_secretsmanager_secret.jwt_secret.id
  secret_string = jsonencode({
    secret = var.jwt_secret
  })
}
