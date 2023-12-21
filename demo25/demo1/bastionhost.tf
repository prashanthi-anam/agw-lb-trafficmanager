# resource "azurerm_subnet" "BastionSubnet" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.rg1.name
#   address_prefixes     = ["192.168.1.224/27"]
# }

# resource "azurerm_public_ip" "bastionip" {
#   name                = "PublicIpforBastion"
#   location            = azurerm_resource_group.rg1.location
#   resource_group_name = azurerm_resource_group.rg1.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "example" {
#   name                = "examplebastion"
#   location            = azurerm_resource_group.rg1.location
#   resource_group_name = azurerm_resource_group.rg1.name
#   scale_units = "2"



#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.example.id
#     public_ip_address_id = azurerm_public_ip.bastionip.id

#   }
# }