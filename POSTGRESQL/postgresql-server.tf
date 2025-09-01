# PostgreSQL Server econômico na subnet privada
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "postgresql-matcarv"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "14"
  administrator_login    = var.postgres_admin_login
  administrator_password = var.postgres_admin_password

  # Configurações econômicas
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  # Desabilitar acesso público
  public_network_access_enabled = false

  # Configurações de segurança
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  tags = merge(local.common_tags, {
    Name        = "postgresql-matcarv"
    Description = "PostgreSQL Server econômico para aplicações"
    Type        = "PostgreSQLServer"
    Tier        = "Basic"
  })
}
