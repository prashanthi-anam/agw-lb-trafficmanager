/*resource "azurerm_lb_nat_rule" "example" {
  resource_group_name            = azurerm_resource_group.rg1.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}*/

resource "azurerm_lb_nat_rule" "example1" {
  resource_group_name            = azurerm_resource_group.rg1.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "RDPAccess2"
  protocol                       = "Tcp"
  frontend_port_start            = 3000
  frontend_port_end              = 3389
  backend_port                   = 3389
  backend_address_pool_id        = azurerm_lb_backend_address_pool.pool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  
}