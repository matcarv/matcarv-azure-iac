# Nome do resource group
variable "resource_group_name" {
  description = "Nome do resource group"
  type        = string
  default     = "rg-matcarv"
}

# Localização dos recursos
variable "location" {
  description = "Localização do Azure"
  type        = string
  default     = "East US"
}

# ID da VNet
variable "virtual_network_id" {
  description = "ID da Virtual Network"
  type        = string
  default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-matcarv/providers/Microsoft.Network/virtualNetworks/vnet-matcarv"
}

# ID da subnet privada para SQL Server
variable "private_subnet_id" {
  description = "ID da subnet privada para SQL Server"
  type        = string
  default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-matcarv/providers/Microsoft.Network/virtualNetworks/vnet-matcarv/subnets/subnet-private-1"
}

# Login do administrador do SQL Server
variable "sql_admin_login" {
  description = "Login do administrador do SQL Server"
  type        = string
  default     = "sqladmin"
}

# Senha do administrador do SQL Server
variable "sql_admin_password" {
  description = "Senha do administrador do SQL Server"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123!"
}

# Nome da zona DNS privada
variable "private_dns_zone_name" {
  description = "Nome da zona DNS privada para SQL Server"
  type        = string
  default     = "privatelink.database.windows.net"
}

# Tags comuns para todos os recursos
locals {
  common_tags = {
    Environment = "Production"
    Project     = "MatCarv"
    CreatedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
    Owner       = "DevOps Team"
  }
}
