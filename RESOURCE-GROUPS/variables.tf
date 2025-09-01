# Região do Azure onde os recursos serão criados
variable "location" {
  description = "Azure region"
  type        = string
  default     = "West US 2"
}

# Nome do resource group principal
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-matcarv"
}

# CIDR da VNet - usado para calcular subnets dinamicamente
variable "vnet_cidr" {
  description = "CIDR block for VNet"
  type        = string
  default     = "171.13.0.0/22"
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
