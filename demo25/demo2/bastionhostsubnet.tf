resource "azurerm_subnet" "bastionsubnet" {
  name                 = "bastionsubnet"
  resource_group_name  = var.resourcegrpname
  address_prefixes     = ["10.0.4.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet1.name

}