#variáveis externas
variable "location" {
  description = "Localização dos recursos"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
}

variable "vmss_id" {
  description = "ID do VMSS"
  type        = string  
}

# variáveis internas do lbl
variable "lb_name" {
  description = "Nome do load balancer"
  type        = string
  default     = "lb-vmss"
}

variable "public_ip_lbl_name" {
  description = "Nome do IP público para o VMSS"
  type        = string
  default     = "lb-vmss-ip"  
}