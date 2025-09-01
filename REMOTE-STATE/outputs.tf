# Resource Group Name
output "resource_group_name" {
  value = azurerm_resource_group.terraform_state.name
}

# Storage Account Name
output "storage_account_name" {
  value = azurerm_storage_account.terraform_state.name
}

# Storage Account Primary Access Key
output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.terraform_state.primary_access_key
  sensitive = true
}

# Container Name
output "container_name" {
  value = azurerm_storage_container.terraform_state.name
}

# Backend Configuration Examples com subpastas
output "backend_config_examples" {
  value = {
    vnet = <<-EOT
      terraform {
        backend "azurerm" {
          resource_group_name  = "${azurerm_resource_group.terraform_state.name}"
          storage_account_name = "${azurerm_storage_account.terraform_state.name}"
          container_name       = "${azurerm_storage_container.terraform_state.name}"
          key                  = "vnet/terraform.tfstate"
        }
      }
    EOT
    
    sql_server = <<-EOT
      terraform {
        backend "azurerm" {
          resource_group_name  = "${azurerm_resource_group.terraform_state.name}"
          storage_account_name = "${azurerm_storage_account.terraform_state.name}"
          container_name       = "${azurerm_storage_container.terraform_state.name}"
          key                  = "sql-server/terraform.tfstate"
        }
      }
    EOT
    
    postgresql = <<-EOT
      terraform {
        backend "azurerm" {
          resource_group_name  = "${azurerm_resource_group.terraform_state.name}"
          storage_account_name = "${azurerm_storage_account.terraform_state.name}"
          container_name       = "${azurerm_storage_container.terraform_state.name}"
          key                  = "postgresql/terraform.tfstate"
        }
      }
    EOT
    
    aks = <<-EOT
      terraform {
        backend "azurerm" {
          resource_group_name  = "${azurerm_resource_group.terraform_state.name}"
          storage_account_name = "${azurerm_storage_account.terraform_state.name}"
          container_name       = "${azurerm_storage_container.terraform_state.name}"
          key                  = "aks/terraform.tfstate"
        }
      }
    EOT
    
    acr = <<-EOT
      terraform {
        backend "azurerm" {
          resource_group_name  = "${azurerm_resource_group.terraform_state.name}"
          storage_account_name = "${azurerm_storage_account.terraform_state.name}"
          container_name       = "${azurerm_storage_container.terraform_state.name}"
          key                  = "acr/terraform.tfstate"
        }
      }
    EOT
  }
}
