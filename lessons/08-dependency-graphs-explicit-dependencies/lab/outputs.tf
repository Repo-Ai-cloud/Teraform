output "resource_group_name" {
  description = "Name of the Azure resource group from this lab."
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Resource ID of the Azure resource group."
  value       = azurerm_resource_group.main.id
}

output "rollout_marker" {
  description = "Local marker that demonstrates an explicit depends_on relationship."
  value       = terraform_data.rollout_marker.output
}
