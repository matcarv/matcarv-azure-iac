# Zona DNS privada para SQL Server
resource "azurerm_private_dns_zone" "sql_server" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = merge(local.common_tags, {
    Name        = var.private_dns_zone_name
    Description = "Zona DNS privada para SQL Server"
    Type        = "PrivateDNSZone"
  })
}

# Link da zona DNS privada com a VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql_server" {
  name                  = "sql-server-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_server.name
  virtual_network_id    = var.virtual_network_id

  tags = merge(local.common_tags, {
    Name        = "sql-server-dns-link"
    Description = "Link DNS privado entre VNet e zona SQL Server"
    Type        = "DNSLink"
  })
}
