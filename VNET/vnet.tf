# Virtual Network principal com CIDR dinâmico
resource "azurerm_virtual_network" "main" {
  name                = "vnet-matcarv"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(local.common_tags, {
    Name        = "vnet-matcarv"
    Description = "Virtual Network principal com subnets públicas e privadas"
    Type        = "VirtualNetwork"
  })
}
