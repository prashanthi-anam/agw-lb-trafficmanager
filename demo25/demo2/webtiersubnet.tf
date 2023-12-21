resource "azurerm_subnet" "websubnet" {
  name                 = "websubnet"
  resource_group_name  = var.resourcegrpname
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet1.name

}
resource "azurerm_network_security_group" "websubnet_nsg" {
  name                = "websubnetnsg"
  location            = var.location
  resource_group_name = var.resourcegrpname

}
resource "azurerm_subnet_network_security_group_association" "websubnetnsgassociation" {
  network_security_group_id = azurerm_network_security_group.websubnet_nsg.id
  subnet_id                 = azurerm_subnet.websubnet.id

}