# Cluster AKS econômico com 2 nodes na subnet privada
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-matcarv"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-matcarv"
  kubernetes_version  = var.kubernetes_version

  # Pool de nodes padrão com instâncias econômicas de 4GB RAM
  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    vnet_subnet_id      = var.aks_subnet_id
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
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
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
    NodeCount   = var.node_count
    VMSize      = var.vm_size
    Security    = "Enhanced"
  })
}
