resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = var.location
  resource_group_name = var.resourcegrpname
  address_space       = ["10.0.0.0/16"]
  depends_on          = [azurerm_resource_group.rg1]
}