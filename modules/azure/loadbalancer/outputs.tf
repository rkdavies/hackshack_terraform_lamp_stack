output "ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "id" {
  value = azurerm_lb.main.id
}
