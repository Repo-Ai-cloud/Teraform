locals {
  tags = {
    course              = "azure-terraform-associate-40-labs"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "34"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-observability-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_prefix}-${var.environment}-${var.workload_name}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 1
  tags                = local.tags
}



