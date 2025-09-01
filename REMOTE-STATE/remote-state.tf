# Resource Group para Remote State
resource "azurerm_resource_group" "terraform_state" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(local.common_tags, {
    Name        = var.resource_group_name
    Description = "Resource Group para armazenar Terraform State"
    Type        = "ResourceGroup"
  })
}

# Storage Account para Remote State
resource "azurerm_storage_account" "terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Configurações de segurança
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  tags = merge(local.common_tags, {
    Name        = var.storage_account_name
    Description = "Storage Account para Terraform Remote State"
    Type        = "StorageAccount"
  })
}

# Container único para todos os módulos (com subpastas via key)
resource "azurerm_storage_container" "terraform_state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}
