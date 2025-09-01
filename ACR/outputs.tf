# IDs dos ACRs criados
output "acr_ids" {
  value = { for k, v in azurerm_container_registry.main : k => v.id }
}

# Nomes dos ACRs criados
output "acr_names" {
  value = { for k, v in azurerm_container_registry.main : k => v.name }
}

# Login servers dos ACRs
output "acr_login_servers" {
  value = { for k, v in azurerm_container_registry.main : k => v.login_server }
}

# Admin usernames (se habilitado)
output "acr_admin_usernames" {
  value = var.admin_enabled ? { for k, v in azurerm_container_registry.main : k => v.admin_username } : {}
}

# Admin passwords (se habilitado)
output "acr_admin_passwords" {
  value     = var.admin_enabled ? { for k, v in azurerm_container_registry.main : k => v.admin_password } : {}
  sensitive = true
}

# Lista simples de login servers
output "login_servers_list" {
  value = [for acr in azurerm_container_registry.main : acr.login_server]
}
