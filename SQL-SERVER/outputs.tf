# FQDN do SQL Server para conexão das aplicações
output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

# Nome do SQL Server
output "sql_server_name" {
  value = azurerm_mssql_server.main.name
}

# Nome do database SQL Server
output "sql_database_name" {
  value = azurerm_mssql_database.main.name
}

# ID do SQL Server
output "sql_server_id" {
  value = azurerm_mssql_server.main.id
}

# Private Endpoint ID
output "private_endpoint_id" {
  value = azurerm_private_endpoint.sql_server.id
}

# Private DNS Zone ID
output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.sql_server.id
}
