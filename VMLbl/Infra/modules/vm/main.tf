resource "azurerm_resource_group" "rs_lab1" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_lab1" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rs_lab1.name
}

resource "azurerm_subnet" "subnet_lab1" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rs_lab1.name
  virtual_network_name = azurerm_virtual_network.vnet_lab1.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "nsg_vm1" {
  name                = var.nsg_vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rs_lab1.name

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

resource "azurerm_public_ip" "pip_lab1" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rs_lab1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_lab1" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rs_lab1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_lab1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_lab1.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_vm1" {
  network_interface_id      = azurerm_network_interface.nic_lab1.id
  network_security_group_id = azurerm_network_security_group.nsg_vm1.id
}

resource "azurerm_linux_virtual_machine" "vm_lab1" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rs_lab1.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic_lab1.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = var.vm_name_disk_name
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}