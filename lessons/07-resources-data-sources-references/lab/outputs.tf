output "resource_group_name" {
  description = "Name of the Azure resource group from this lab."
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Resource ID of the Azure resource group."
  value       = azurerm_resource_group.main.id
}

output "active_azure_context" {
  description = "Non-secret identifiers read from the active Azure provider context."
  value = {
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
    object_id       = data.azurerm_client_config.current.object_id
  }
}
