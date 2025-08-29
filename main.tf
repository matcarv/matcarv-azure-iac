# Configuração do Terraform e provider Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Provider Azure com features habilitadas
provider "azurerm" {
  features {}
}
