# IP público para o NAT Gateway
resource "azurerm_public_ip" "nat_gateway" {
  name                = "pip-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
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
  location            = var.location
  resource_group_name = var.resource_group_name
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
