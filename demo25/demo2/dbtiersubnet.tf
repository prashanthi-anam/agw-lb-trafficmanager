resource "azurerm_subnet" "dbsubnet" {
  name                 = "dbsubnet"
  resource_group_name  = var.resourcegrpname
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet1.name

}
resource "azurerm_network_security_group" "dbsubnet_nsg" {
  name                = "dbsubnetnsg"
  location            = var.location
  resource_group_name = var.resourcegrpname

}
resource "azurerm_subnet_network_security_group_association" "dbsubnetnsgassociation" {
  network_security_group_id = azurerm_network_security_group.dbsubnet_nsg.id
  subnet_id                 = azurerm_subnet.dbsubnet.id

}