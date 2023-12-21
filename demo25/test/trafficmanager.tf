

resource "azurerm_traffic_manager_profile" "example" {
  name                   = "trafficmanager-profile"
  resource_group_name    = azurerm_resource_group.rg1.name
  traffic_routing_method = "Weighted"
  

  dns_config {
    relative_name = "prashanthi-profile"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "example" {
  name               = "example-endpoint"
  profile_id         = azurerm_traffic_manager_profile.example.id
  weight             = 100
 
  target_resource_id = azurerm_public_ip.example.id
   

}