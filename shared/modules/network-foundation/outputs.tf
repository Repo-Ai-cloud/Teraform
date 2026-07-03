output "summary" {
  description = "Network resource identifiers."
  value = {
    resource_group_name = azurerm_resource_group.network.name
    virtual_network_id  = azurerm_virtual_network.main.id
    subnet_ids          = { for key, subnet in azurerm_subnet.subnet : key => subnet.id }
  }
}
