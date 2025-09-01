# Log Analytics Workspace para monitoramento
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-analytics-matcarv"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = merge(local.common_tags, {
    Name        = "log-analytics-matcarv"
    Description = "Log Analytics para monitoramento do AKS"
    Type        = "LogAnalytics"
  })
}
