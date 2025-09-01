# Zona DNS privada para PostgreSQL Server
resource "azurerm_private_dns_zone" "postgresql_server" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name

  tags = merge(local.common_tags, {
    Name        = var.private_dns_zone_name
    Description = "Zona DNS privada para PostgreSQL Server"
    Type        = "PrivateDNSZone"
  })
}

# Link da zona DNS privada com a VNet
resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_server" {
  name                  = "postgresql-server-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql_server.name
  virtual_network_id    = var.virtual_network_id

  tags = merge(local.common_tags, {
    Name        = "postgresql-server-dns-link"
    Description = "Link DNS privado entre VNet e zona PostgreSQL Server"
    Type        = "DNSLink"
  })
}
