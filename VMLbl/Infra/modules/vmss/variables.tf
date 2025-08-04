#variáveis externas
variable "location" {
  description = "Localização dos recursos"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
}

variable "admin_username" {
  description = "Nome do usuário administrador da VM"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
}

variable "subnet_id" {
  description = "ID da sub-rede"
  type        = string
}

variable "snapshot_id" {
  type = string
  description = "ID do snapshot da VM lab1"
}

#Variáveis internas do módulo VMSS
variable "nsg_vmss_name" {
  description = "Nome do grupo de segurança de rede para o VMSS"
  type        = string
  default     = "nsg-vmss"
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

variable "vmss_autoscale_name" {
  description = "Nome da configuração de autoescalamento"
  type        = string
  default     = "vmss-autoscale"
}

variable "lb_name" {
  description = "Nome do load balancer"
  type        = string
  default     = "lb-vmss"
}


