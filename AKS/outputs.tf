# Nome do cluster AKS para conexão via kubectl
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

# ID do cluster AKS
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

# FQDN do cluster AKS
output "aks_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

# Kube config para conexão
output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}

# ID do Log Analytics Workspace
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

# Nome do Log Analytics Workspace
output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}
