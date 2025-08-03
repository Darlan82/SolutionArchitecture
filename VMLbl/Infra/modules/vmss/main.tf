resource "azurerm_network_security_group" "nsg_vmss" {
  name                = var.nsg_vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-Inbound"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_managed_disk" "vmss_disk" {
  name                 = "vmss-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Copy"
  source_resource_id   = var.snapshot_id
}

# Criar uma imagem gerenciada a partir do snapshot
resource "azurerm_image" "vmss_image" {
  name                = "vmss-image"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_disk {
    os_type            = "Linux"
    managed_disk_id    = azurerm_managed_disk.vmss_disk.id
    caching            = "ReadWrite"
    os_state           = "Specialized" # Use "Specialized" for existing VMs
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss_lab1" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vmss_sku
  instances           = var.vmss_instances
  admin_username      = var.admin_username

  source_image_id = azurerm_image.vmss_image.id

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true
    network_security_group_id = azurerm_network_security_group.nsg_vmss.id

    ip_configuration {
      name      = "vmss-ipconfig"
      subnet_id = var.subnet_id
    }
  }

  upgrade_mode = "Manual"
}

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = var.vmss_autoscale_name
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss_lab1.id

  profile {
    name = "default"
    capacity {
      minimum = var.vmss_min_instances
      maximum = var.vmss_max_instances
      default = var.vmss_min_instances
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss_lab1.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 60
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss_lab1.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}