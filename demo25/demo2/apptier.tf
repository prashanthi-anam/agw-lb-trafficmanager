resource "azurerm_subnet" "appsubnet" {
  name                 = "appsubnet"
  resource_group_name  = var.resourcegrpname
  address_prefixes     = ["10.0.3.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet1.name

}
resource "azurerm_network_security_group" "appsubnet_nsg" {
  name                = "appsubnetnsg"
  location            = var.location
  resource_group_name = var.resourcegrpname

}
resource "azurerm_subnet_network_security_group_association" "appsubnetnsgassociation" {
  network_security_group_id = azurerm_network_security_group.appsubnet_nsg.id
  subnet_id                 = azurerm_subnet.appsubnet.id

}
resource "azurerm_network_security_rule" "example" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.appsubnet_nsg.name
}