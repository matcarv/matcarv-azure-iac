# VNet ID
output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

# VNet name
output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

# Subnet IDs
output "public_subnet_1_id" {
  value = azurerm_subnet.public_1.id
}

output "public_subnet_2_id" {
  value = azurerm_subnet.public_2.id
}

output "private_subnet_1_id" {
  value = azurerm_subnet.private_1.id
}

output "private_subnet_2_id" {
  value = azurerm_subnet.private_2.id
}

# NAT Gateway ID
output "nat_gateway_id" {
  value = azurerm_nat_gateway.main.id
}
