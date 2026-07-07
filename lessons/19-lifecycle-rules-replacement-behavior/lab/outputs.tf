output "resource_group_name" {
  description = "Name of the Azure resource group from this lab."
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Resource ID of the Azure resource group."
  value       = azurerm_resource_group.main.id
}

output "replacement_marker" {
  description = "Local marker that demonstrates create_before_destroy lifecycle behavior."
  value       = terraform_data.replacement_marker.output
}
