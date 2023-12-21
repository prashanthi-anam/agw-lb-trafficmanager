resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  depends_on          = [azurerm_resource_group.rg1]
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_resource_group.rg1, azurerm_virtual_network.example]
}
resource "azurerm_public_ip" "example1" {
  name                = "PublicIPForVm"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  #sku                 = "Standard"
  sku               = "Basic" # Use "Basic" SKU to match the Load Balancer SKU
  allocation_method = "Static"
}
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    public_ip_address_id          = azurerm_public_ip.example1.id
    private_ip_address_allocation = "Dynamic"

  }
}
# Resource-3 (Optional) : Create Network Security Group and associate it with Network Interface

#Resoure-1 : Create Network Security Group (NSG)
resource "azurerm_network_security_group" "web_linuxvm_nsg" {
  name                = "${azurerm_network_interface.example.name}-nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

#Resource-2 : Associate NSG and Linux VM NIC
resource "azurerm_subnet_network_security_group_association" "web_linuxvm_nic_nsg_association" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.web_linuxvm_nsg.id
}

#Resource-3 : Create NSG Rules
##Loccal Block for Security Rules

locals {
  web_vmnic_inbound_ports_map = {
    "100" : "80", #If the key start with a number, then we need to : instead of =
    "110" : "3389",
    #"120" : "22"
  }
}

## NSG Inbound Rules for WebTier VM NIC
resource "azurerm_network_security_rule" "web_vmnic_nsg_rule_inbound" {
  for_each                    = local.web_vmnic_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.web_linuxvm_nsg.name
}
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  size                = "Standard_F2"
  admin_username      = "prashanthi"
  admin_password      = "Prashanthi@1234"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  # custom_data = filebase64("${path.module}/app-scripts/webvm-script.sh")
  custom_data = base64encode(<<CUSTOM_DATA
<powershell>
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Add-Content -Path C:\inetpub\wwwroot\index.html -Value @"
<!DOCTYPE html>
<html>
<head>
    <title>Hello, Azure IIS!</title>
</head>
<body>
    <h1>Hello, Azure IIS!</h1>
    <p>This is a simple HTML page served by IIS on Azure VM.</p>
</body>
</html>
"@
</powershell>
CUSTOM_DATA
  )

  tags = {
    environment = "production"
  }
}
#Agent for Windows
#Agent for Windows
/*resource "azurerm_virtual_machine_extension" "MMA" {
  name                       = "test-MMAextension"
  virtual_machine_id         = azurerm_windows_virtual_machine.example.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId" : "${azurerm_log_analytics_workspace.example.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${azurerm_log_analytics_workspace.example.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

# Dependency Agent for Windows
resource "azurerm_virtual_machine_extension" "da" {
  name                       = "DAExtension"
  virtual_machine_id         = azurerm_windows_virtual_machine.example.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.5"
  auto_upgrade_minor_version = true

}*/



