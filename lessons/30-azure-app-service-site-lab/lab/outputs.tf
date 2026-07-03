output "site_hostname" {
  description = "Default hostname for the App Service site."
  value       = azurerm_linux_web_app.main.default_hostname
}

output "managed_identity_principal_id" {
  description = "System-assigned managed identity principal ID."
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "operational_tags" {
  description = "Tags applied to Azure resources for operations, governance, and cost review."
  value       = local.tags
}
