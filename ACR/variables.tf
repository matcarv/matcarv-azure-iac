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

# Array de nomes para ACR
variable "acr_names" {
  description = "Lista de nomes para Azure Container Registry"
  type        = list(string)
  default     = ["acrmatcarv", "acrmatcarvdev"]
}

# SKU do ACR
variable "acr_sku" {
  description = "SKU do Azure Container Registry"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU deve ser Basic, Standard ou Premium."
  }
}

# Habilitar admin user
variable "admin_enabled" {
  description = "Habilitar usuário admin no ACR"
  type        = bool
  default     = false
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
