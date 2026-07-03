output "workspace_id" {
  description = "Log Analytics workspace resource ID."
  value       = azurerm_log_analytics_workspace.main.id
}

output "workspace_customer_id" {
  description = "Workspace customer ID used by agents and diagnostics."
  value       = azurerm_log_analytics_workspace.main.workspace_id
}
