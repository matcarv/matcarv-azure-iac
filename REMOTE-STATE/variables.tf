# Nome do resource group para remote state
variable "resource_group_name" {
  description = "Nome do resource group para remote state"
  type        = string
  default     = "rg-terraform-state"
}

# Localização dos recursos
variable "location" {
  description = "Localização do Azure"
  type        = string
  default     = "East US"
}

# Nome da storage account
variable "storage_account_name" {
  description = "Nome da storage account para remote state"
  type        = string
  default     = "tfstatematcarv"
}

# Nome do container
variable "container_name" {
  description = "Nome do container para remote state"
  type        = string
  default     = "tfstate"
}

# Tags comuns para todos os recursos
locals {
  common_tags = {
    Environment = "Production"
    Project     = "MatCarv"
    CreatedBy   = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
    Owner       = "DevOps Team"
    Purpose     = "TerraformState"
  }
}
