output "connection_string" {
  value     = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Database=${var.db_name};User Id=${var.db_username};Password=${var.db_password};Encrypt=true;TrustServerCertificate=false;"
  sensitive = true
}

output "server_id" {
  value = azurerm_mssql_server.main.id
}
