output "resource_group_names" {
  description = "Regional resource group names keyed by logical region."
  value       = { for key, group in azurerm_resource_group.regional : key => group.name }
}
