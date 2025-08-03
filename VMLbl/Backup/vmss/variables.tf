variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
}

variable "location" {
  description = "Localização dos recursos"
  type        = string
}

variable "vm_name" {
  description = "Nome da máquina virtual"
  type        = string
}

variable "disk_name" {
  description = "Nome do disco gerenciado"
  type        = string
  default     = "disk-from-snapshot-vm-lab1"
}

variable "image_name" {
  description = "Nomeunofficial source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set"
  type        = string
  default     = "image-vm-lab1"
}

variable "nsg_vmss_name" {
  description = "Nome do grupo de segurança de rede para o VMSS"
  type        = string
  default     = "nsg-vmss"
}

variable "lb_name" {
  description = "Nome do load balancer"
  type        = string
  default     = "lb-vmss"
}

variable "public_ip_id" {
  description = "ID do IP público"
  type        = string
}

variable "vmss_name" {
  description = "Nome do VMSS"
  type        = string
  default     = "vmss-lab1"
}

variable "vmss_sku" {
  description = "SKU do VMSS"
  type        = string
  default     = "Standard_B1s"
}

variable "vmss_instances" {
  description = "Número inicial de instâncias do VMSS"
  type        = number
  default     = 3
}

variable "vmss_min_instances" {
  description = "Número mínimo de instâncias do VMSS"
  type        = number
  default     = 3
}

variable "vmss_max_instances" {
  description = "Número máximo de instâncias do VMSS"
  type        = number
  default     = 10
}

variable "vmss_default_instances" {
  description = "Número padrão de instâncias do VMSS"
  type        = number
  default     = 3
}

variable "admin_username" {
  description = "Nome do usuário administrador do VMSS"
  type        = string
  default     = "azureuser"
}

variable "subnet_id" {
  description = "ID da sub-rede"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
  default     = "./id_rsa.pub"
}

variable "autoscale_name" {
  description = "Nome da configuração de autoescalamento"
  type        = string
  default     = "vmss-autoscale"
}