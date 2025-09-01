# Private Endpoint para PostgreSQL Server
resource "azurerm_private_endpoint" "postgresql_server" {
  name                = "pe-postgresql-matcarv"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "psc-postgresql"
    private_connection_resource_id = azurerm_postgresql_flexible_server.main.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.postgresql_server.id]
  }

  tags = merge(local.common_tags, {
    Name        = "pe-postgresql-matcarv"
    Description = "Private Endpoint para PostgreSQL Server"
    Type        = "PrivateEndpoint"
  })
}
