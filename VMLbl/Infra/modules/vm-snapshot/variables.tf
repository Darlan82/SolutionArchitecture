variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
}

variable "location" {
  description = "Localização dos recursos"
  type        = string
}

variable "vm_name_disk_name" {
  description = "Nome do disco da máquina virtual"
  type        = string
  default = "osdisk-vm-lab1"
}

variable "disk_name" {
  description = "Nome do disco gerenciado"
  type        = string
  default     = "disk-from-snapshot-vm-lab1"
}

variable "image_name" {
  description = ""
  type        = string
  default     = "image-vm-lab1"
}