# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "db-matcarv"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
