resource "azurerm_mssql_database" "main" {
  name      = var.db_name
  server_id = azurerm_mssql_server.main.id

  sku_name = var.instance_class

  tags = var.tags
}

resource "azurerm_mssql_server" "main" {
  name                         = "azure-lamp-sql"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login          = var.db_username
  administrator_login_password = var.db_password
  version                      = "12.0"

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "allow-all"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
