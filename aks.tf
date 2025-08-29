# Cluster AKS econômico com 2 nodes na subnet privada
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-matcarv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-matcarv"
  kubernetes_version  = "1.30.14"

  # Pool de nodes padrão com instâncias econômicas de 4GB RAM
  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_B2s"
    vnet_subnet_id      = azurerm_subnet.private_2.id
    enable_auto_scaling = false

    # Configurações de segurança do node pool
    upgrade_settings {
      max_surge = "10%"
    }
  }

  # Identidade gerenciada pelo sistema para o cluster
  identity {
    type = "SystemAssigned"
  }

  # Configuração de rede Azure CNI para integração com VNet
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    service_cidr      = "10.0.0.0/16"
    dns_service_ip    = "10.0.0.10"
    load_balancer_sku = "standard"
  }

  # Configurações de segurança avançadas
  role_based_access_control_enabled = true

  # Microsoft Defender para Kubernetes
  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  # Configurações de monitoramento
  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.main.id
    msi_auth_for_monitoring_enabled = true
  }

  # Key Vault Secrets Provider
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = merge(local.common_tags, {
    Name        = "aks-matcarv"
    Description = "Cluster Kubernetes econômico para aplicações containerizadas"
    Type        = "Kubernetes"
    NodeCount   = "2"
    VMSize      = "Standard_B2s"
    Security    = "Enhanced"
  })
}

# Log Analytics Workspace para monitoramento
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-analytics-matcarv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = merge(local.common_tags, {
    Name        = "log-analytics-matcarv"
    Description = "Log Analytics para monitoramento do AKS"
    Type        = "LogAnalytics"
  })
}
