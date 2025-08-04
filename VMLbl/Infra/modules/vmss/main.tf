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

# Load Balancer

# IP Público para o Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb_vmss" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "lb-frontend-vmss"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool_vmss" {
  name            = "lb-backend-pool-vmss"
  loadbalancer_id = azurerm_lb.lb_vmss.id
}

resource "azurerm_lb_rule" "lb_rule_http_vmss" {
  name                           = "lb-rule-http-vmss"
  loadbalancer_id                = azurerm_lb.lb_vmss.id
  frontend_ip_configuration_name = "lb-frontend-vmss"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool_vmss.id]
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 4
}

resource "azurerm_managed_disk" "vmss_disk" {
  name                 = "vmss-disk"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Copy"
  source_resource_id   = var.snapshot_id
}

resource "azurerm_image" "vmss_image" {
  name                = "vmss-image"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_disk {
    os_type            = "Linux" # Ou "Windows", dependendo do sistema operacional
    managed_disk_id    = azurerm_managed_disk.vmss_disk.id
    caching            = "ReadWrite"
    os_state           = "Generalized" # Ajuste para "Generalized" se necessário
    storage_type       = "Standard_LRS"
  }

  hyper_v_generation = "V2"
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