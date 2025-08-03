output "resource_group_name" {
  value = azurerm_resource_group.rs_lab1.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rs_lab1.location
}

output "subnet_id" {
  value = azurerm_subnet.subnet_lab1.id
}

output "public_ip_address" {
  value = azurerm_public_ip.pip_lab1.ip_address
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm_lab1.name
}

output "admin_username" {
  value = var.admin_username  
}

output "ssh_public_key_path" {
  value = var.ssh_public_key_path  
}
