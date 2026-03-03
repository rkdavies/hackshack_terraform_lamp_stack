output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_id" {
  value = azurerm_subnet.web.id
}

output "database_subnet_id" {
  value = azurerm_subnet.database.id
}

output "security_group_id" {
  value = azurerm_network_security_group.web.id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
