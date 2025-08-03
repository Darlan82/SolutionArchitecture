variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
  default     = "Rs-Lab1"
}

variable "location" {
  description = "Localização dos recursos"
  type        = string
  default     = "Brazil South"
}

variable "vnet_name" {
  description = "Nome da rede virtual"
  type        = string
  default     = "vnet-lab1"
}

variable "vnet_address_space" {
  description = "Espaço de endereço da rede virtual"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Nome da sub-rede"
  type        = string
  default     = "subnet-lab1"
}

variable "subnet_address_prefixes" {
  description = "Prefixos de endereço da sub-rede"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "nsg_vm_name" {
  description = "Nome do grupo de segurança de rede para a VM"
  type        = string
  default     = "nsg-vm1"
}

variable "public_ip_name" {
  description = "Nome do IP público"
  type        = string
  default     = "pip-lab1"
}

variable "nic_name" {
  description = "Nome da interface de rede"
  type        = string
  default     = "nic-lab1"
}

variable "vm_name" {
  description = "Nome da máquina virtual"
  type        = string
  default     = "vm-lab1"
}

variable "vm_name_disk_name" {
  description = "Nome do disco da máquina virtual"
  type        = string
  default     = "osdisk-vm-lab1"
}

variable "vm_size" {
  description = "Tamanho da máquina virtual"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Nome do usuário administrador da VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
  default     = "./id_rsa.pub"
}