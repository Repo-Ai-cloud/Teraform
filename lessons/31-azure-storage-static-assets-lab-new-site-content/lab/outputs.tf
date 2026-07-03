output "static_site_endpoint" {
  description = "Primary static website endpoint."
  value       = azurerm_storage_account.site.primary_web_endpoint
}
