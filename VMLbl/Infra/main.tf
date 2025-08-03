module "vm" {
  source = "./modules/vm"
}

module "vm-snapshot" {
  source              = "./modules/vm-snapshot"
  resource_group_name = module.vm.resource_group_name
  location            = module.vm.resource_group_location

  depends_on = [module.vm]
}

module "vmss" {
  source = "./modules/vmss"

  # Variáveis criadas na VM
  resource_group_name = module.vm.resource_group_name
  location            = module.vm.resource_group_location
  admin_username      = module.vm.admin_username
  ssh_public_key_path = module.vm.ssh_public_key_path
  subnet_id           = module.vm.subnet_id

  # Variáveis criadas no snapshot
  snapshot_id         = module.vm-snapshot.snapshot_id

  depends_on          = [
    module.vm,
    module.vm-snapshot
    ]
}

module "lbl_vms_vmss" {
  source = "./modules/lbl_vms_vmss"

  resource_group_name = module.vm.resource_group_name
  location            = module.vm.resource_group_location

  vmss_id             = module.vmss.vmss_id

  depends_on          = [module.vmss]
}