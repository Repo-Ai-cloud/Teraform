output "backend_configuration" {
  description = "Non-secret values to copy into backend.azurerm.tfbackend. Authentication remains in the Azure CLI session."
  value = {
    resource_group_name  = azurerm_resource_group.state.name
    storage_account_name = azurerm_storage_account.state.name
    container_name       = azurerm_storage_container.state.name
    key                  = "lesson-22/workload.tfstate"
    use_cli              = true
    use_azuread_auth     = true
  }
}

output "backend_role_scope" {
  description = "Container-level scope of the Storage Blob Data Contributor assignment."
  value       = azurerm_role_assignment.state_blob_data.scope
}
