# Virtual Network principal com CIDR dinâmico
resource "azurerm_virtual_network" "main" {
  name                = "vnet-matcarv"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(local.common_tags, {
    Name        = "vnet-matcarv"
    Description = "Virtual Network principal com subnets públicas e privadas"
    Type        = "VirtualNetwork"
  })
}

# IP público para o NAT Gateway
resource "azurerm_public_ip" "nat_gateway" {
  name                = "pip-nat-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(local.common_tags, {
    Name        = "pip-nat-gateway"
    Description = "IP público para NAT Gateway - conectividade de saída"
    Type        = "PublicIP"
  })
}

# NAT Gateway para conectividade de saída das subnets privadas
resource "azurerm_nat_gateway" "main" {
  name                = "nat-gateway-matcarv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Standard"

  tags = merge(local.common_tags, {
    Name        = "nat-gateway-matcarv"
    Description = "NAT Gateway para acesso de saída das subnets privadas"
    Type        = "NATGateway"
  })
}

# Associação do IP público ao NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

# Subnet pública 1 - CIDR calculado dinamicamente
resource "azurerm_subnet" "public_1" {
  name                 = "subnet-public-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 0)]
}

# Subnet pública 2 - CIDR calculado dinamicamente
resource "azurerm_subnet" "public_2" {
  name                 = "subnet-public-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 1)]
}

# Subnet privada 1 - Para SQL Server com service endpoint
resource "azurerm_subnet" "private_1" {
  name                 = "subnet-private-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 2)]
  service_endpoints    = ["Microsoft.Sql"]
}

# Subnet privada 2 - Para AKS com service endpoint
resource "azurerm_subnet" "private_2" {
  name                 = "subnet-private-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 2, 3)]
  service_endpoints    = ["Microsoft.Sql"]
}

# Associação do NAT Gateway à subnet privada 1 (PostgreSQL)
resource "azurerm_subnet_nat_gateway_association" "private_1" {
  subnet_id      = azurerm_subnet.private_1.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Associação do NAT Gateway à subnet privada 2 (AKS)
resource "azurerm_subnet_nat_gateway_association" "private_2" {
  subnet_id      = azurerm_subnet.private_2.id
  nat_gateway_id = azurerm_nat_gateway.main.id
}
