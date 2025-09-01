# Azure Container Registry com suporte a múltiplas instâncias
resource "azurerm_container_registry" "main" {
  for_each = toset(var.acr_names)

  name                = each.value
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.admin_enabled

  # Configurações de segurança
  public_network_access_enabled = false
  network_rule_bypass_option    = "AzureServices"

  tags = merge(local.common_tags, {
    Name        = each.value
    Description = "Azure Container Registry para imagens Docker"
    Type        = "ContainerRegistry"
    SKU         = var.acr_sku
  })
}
