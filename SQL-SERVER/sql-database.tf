# SQL Database econômico
resource "azurerm_mssql_database" "main" {
  name           = "db-matcarv"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
  zone_redundant = false

  # Configurações de criptografia
  transparent_data_encryption_enabled = true

  # Configurações de backup
  short_term_retention_policy {
    retention_days = 7
  }

  tags = merge(local.common_tags, {
    Name        = "db-matcarv"
    Description = "Database principal para aplicações"
    Type        = "SQLDatabase"
    Tier        = "Basic"
  })
}
