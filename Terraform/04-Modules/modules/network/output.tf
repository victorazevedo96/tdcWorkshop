output "virtual_network_id" {
  value = azurerm_virtual_network.this.id
}

output "subnet_id" {
  value = azurerm_subnet.this.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.this.name
}