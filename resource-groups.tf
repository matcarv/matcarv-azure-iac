# Resource Group principal para todos os recursos da infraestrutura
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(local.common_tags, {
    Name        = var.resource_group_name
    Description = "Resource Group principal para infraestrutura MatCarv"
    Type        = "ResourceGroup"
  })
}
