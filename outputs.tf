# Nome do cluster AKS para conexão via kubectl
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

# FQDN do SQL Server para conexão das aplicações
output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}

# Nome do database SQL Server
output "sql_database_name" {
  value = azurerm_mssql_database.main.name
}

# Nome do resource group criado
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
