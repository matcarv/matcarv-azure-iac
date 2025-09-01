# Private Endpoint para SQL Server
resource "azurerm_private_endpoint" "sql_server" {
  name                = "pe-sqlserver-matcarv"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "psc-sqlserver"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_server.id]
  }

  tags = merge(local.common_tags, {
    Name        = "pe-sqlserver-matcarv"
    Description = "Private Endpoint para SQL Server"
    Type        = "PrivateEndpoint"
  })
}
