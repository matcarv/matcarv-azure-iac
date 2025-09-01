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

# CIDR da VNet - usado para calcular subnets dinamicamente
variable "vnet_cidr" {
  description = "CIDR block for VNet"
  type        = string
  default     = "171.13.0.0/22"
}

# Service endpoints para subnets privadas
variable "service_endpoints" {
  description = "Lista de service endpoints para subnets privadas"
  type        = list(string)
  default     = ["Microsoft.Sql"]
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
