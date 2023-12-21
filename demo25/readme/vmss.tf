

# resource "azurerm_virtual_network" "example" {
#   name                = "acctvn"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet" "example" {
#   name = "acctsub"

#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# resource "azurerm_public_ip" "example" {
#   name                = "test"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   domain_name_label   = "rg-label"
#   tags = {
#     environment = "staging"
#   }
# }

# resource "azurerm_lb" "example" {
#   name                = "test"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.example.id
#   }
# }

# resource "azurerm_lb_backend_address_pool" "bpepool" {
#   loadbalancer_id = azurerm_lb.example.id
#   name            = "BackEndAddressPool"
# }

/*resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}*/
# resource "azurerm_lb_rule" "example" {
#   loadbalancer_id                = azurerm_lb.example.id
#   name                           = "LBRule"
#   protocol                       = "Tcp"
#   frontend_port                  = 3389
#   backend_port                   = 3389
#   frontend_ip_configuration_name = "PublicIPAddress"
#   backend_address_pool_ids = [ azurerm_lb_backend_address_pool.bpepool.id ]
#   probe_id = azurerm_lb_probe.example.id
# }

# resource "azurerm_lb_probe" "example" {
#   loadbalancer_id = azurerm_lb.example.id
#   name            = "http-probe"
#   protocol        = "Http"
#   request_path    = "/health"
#   port            = 8080
# }

resource "azurerm_windows_virtual_machine_scale_set" "example" {
  name                 = "example-vmss"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  sku                  = "Standard_F2"
  instances            = 1
  admin_password       = "P@55w0rd1234!"
  admin_username       = "adminuser"
  computer_name_prefix = "vm-"
  upgrade_mode         = "Automatic"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.backend.id
      #load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      application_gateway_backend_address_pool_ids = [ azurerm_application_gateway.network.id ]
    }
  }

}
