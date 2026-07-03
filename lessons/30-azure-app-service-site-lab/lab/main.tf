resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

locals {
  base_name = substr(lower(replace("${var.project_prefix}-${var.environment}-${var.workload_name}", "-", "")), 0, 18)
  tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "30"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-app-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_service_plan" "main" {
  name                = "${var.project_prefix}-${var.environment}-${var.workload_name}-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = local.tags
}

resource "azurerm_linux_web_app" "main" {
  name                    = "${local.base_name}${random_string.suffix.result}"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  service_plan_id         = azurerm_service_plan.main.id
  https_only              = true
  client_affinity_enabled = false
  tags                    = local.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = false
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"

    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    TRAINING_SCENARIO        = "event-check-in"
  }
}




