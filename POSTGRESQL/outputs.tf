# FQDN do PostgreSQL Server para conexão das aplicações
output "postgresql_server_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

# Nome do PostgreSQL Server
output "postgresql_server_name" {
  value = azurerm_postgresql_flexible_server.main.name
}

# Nome do database PostgreSQL
output "postgresql_database_name" {
  value = azurerm_postgresql_flexible_server_database.main.name
}

# ID do PostgreSQL Server
output "postgresql_server_id" {
  value = azurerm_postgresql_flexible_server.main.id
}

# Private Endpoint ID
output "private_endpoint_id" {
  value = azurerm_private_endpoint.postgresql_server.id
}

# Private DNS Zone ID
output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgresql_server.id
}
