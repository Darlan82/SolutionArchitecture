output "public_ip_address" {
  value       = module.vm.public_ip_address
  description = "IP público da VM para acesso via SSH"
}