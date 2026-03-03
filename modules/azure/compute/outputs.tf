output "instance_id" {
  value = azurerm_linux_virtual_machine.web.id
}

output "ip_address" {
  value = azurerm_network_interface.web.private_ip_address
}

output "backend_pool" {
  value = azurerm_network_interface.web.id
}
