# Configuração do Terraform e provider Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatematcarv"
    container_name       = "tfstate"
    key                  = "vnet/terraform.tfstate"
  }
}

# Provider Azure com features habilitadas
provider "azurerm" {
  features {}
}
