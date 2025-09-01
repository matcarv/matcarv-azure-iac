# SQL Server econômico na subnet privada
resource "azurerm_mssql_server" "main" {
  name                         = "sqlserver-matcarv"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  # Desabilitar acesso público
  public_network_access_enabled = false

  # Configurações de segurança
  minimum_tls_version = "1.2"

  tags = merge(local.common_tags, {
    Name        = "sqlserver-matcarv"
    Description = "SQL Server econômico para aplicações"
    Type        = "SQLServer"
    Tier        = "Basic"
  })
}
