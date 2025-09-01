# Subnet pública 1 - CIDR calculado dinamicamente
resource "azurerm_subnet" "public_1" {
  name                 = "subnet-public-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 0)]
}

# Subnet pública 2 - CIDR calculado dinamicamente
resource "azurerm_subnet" "public_2" {
  name                 = "subnet-public-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 1)]
}

# Subnet privada 1 - Para SQL Server com service endpoint
resource "azurerm_subnet" "private_1" {
  name                 = "subnet-private-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 2)]
  service_endpoints    = var.service_endpoints
}

# Subnet privada 2 - Para AKS com service endpoint
resource "azurerm_subnet" "private_2" {
  name                 = "subnet-private-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 3)]
  service_endpoints    = var.service_endpoints
}
