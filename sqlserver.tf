# SQL Server econômico na subnet privada
resource "azurerm_mssql_server" "main" {
  name                         = "sqlserver-matcarv"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd123!"

  # Desabilitar acesso público
  public_network_access_enabled = false
  
  # Configurações de segurança
  minimum_tls_version = "1.2"

  tags = merge(local.common_tags, {
    Name        = "sqlserver-matcarv"
    Description = "SQL Server econômico para aplicações"
    Type        = "SQLServer"
    Tier        = "Basic"
  })
}

# SQL Database econômico
resource "azurerm_mssql_database" "main" {
  name           = "db-matcarv"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
  zone_redundant = false

  tags = merge(local.common_tags, {
    Name        = "db-matcarv"
    Description = "Database principal para aplicações"
    Type        = "SQLDatabase"
    Tier        = "Basic"
  })
}

# Private Endpoint para SQL Server
resource "azurerm_private_endpoint" "sql_server" {
  name                = "pe-sqlserver-matcarv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_1.id

  private_service_connection {
    name                           = "psc-sqlserver"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_server.id]
  }

  tags = merge(local.common_tags, {
    Name        = "pe-sqlserver-matcarv"
    Description = "Private Endpoint para SQL Server"
    Type        = "PrivateEndpoint"
  })
}

# Zona DNS privada para SQL Server
resource "azurerm_private_dns_zone" "sql_server" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.main.name

  tags = merge(local.common_tags, {
    Name        = "privatelink.database.windows.net"
    Description = "Zona DNS privada para SQL Server"
    Type        = "PrivateDNSZone"
  })
}

# Link da zona DNS privada com a VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql_server" {
  name                  = "sql-server-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_server.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = merge(local.common_tags, {
    Name        = "sql-server-dns-link"
    Description = "Link DNS privado entre VNet e zona SQL Server"
    Type        = "DNSLink"
  })
}
