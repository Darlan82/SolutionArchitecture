# Buscar o disco gerenciado da VM
data "azurerm_managed_disk" "vm_lab1_os_disk" {
  name                = var.vm_name_disk_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_snapshot" "snapshot_vm_lab1" {
  name                = "snapshot-vm-lab1"
  resource_group_name = var.resource_group_name
  location            = var.location
  source_uri          = data.azurerm_managed_disk.vm_lab1_os_disk.id
  create_option       = "Copy"
}

