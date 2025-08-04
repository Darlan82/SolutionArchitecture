resource "azurerm_lb" "lb_vmss" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "lb-frontend-vmss"
    public_ip_address_id = var.vmss_id
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
