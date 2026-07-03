output "container_app_url" {
  description = "Container app URL."
  value       = azurerm_container_app.worker.latest_revision_fqdn
}

output "managed_identity_principal_id" {
  description = "System-assigned managed identity principal ID for the container app."
  value       = azurerm_container_app.worker.identity[0].principal_id
}
