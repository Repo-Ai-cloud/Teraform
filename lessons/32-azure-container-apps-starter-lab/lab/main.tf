resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

locals {
  name = "${var.project_prefix}-${var.environment}-${var.workload_name}-${random_string.suffix.result}"
  tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "32"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name}-ca-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.name}-logs"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 1
  tags                = local.tags
}

resource "azurerm_container_app_environment" "main" {
  name                       = "${local.name}-env"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.tags
}

resource "azurerm_container_app" "worker" {
  name                         = "${local.name}-worker"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.tags

  identity {
    type = "SystemAssigned"
  }

  template {
    min_replicas = 0
    max_replicas = 1

    container {
      name   = "hello"
      image  = "mcr.microsoft.com/k8se/quickstart@sha256:d24e95e1a58337150837336b665071af6bf823620ca9b27e71f9cb4c825434a0"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "APP_MODE"
        value = "training"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}




