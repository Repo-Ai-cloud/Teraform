resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  vault_name = substr(lower(replace("${var.project_prefix}-${var.environment}-${var.workload_name}-${random_string.suffix.result}", "-", "")), 0, 24)
  tags = {
    course              = "azure-terraform-associate-40-labs"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "33"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-secure-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_user_assigned_identity" "app" {
  name                = "${var.project_prefix}-${var.environment}-${var.workload_name}-id"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_key_vault" "main" {
  name                          = local.vault_name
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = false
  soft_delete_retention_days    = 7
  rbac_authorization_enabled    = true
  public_network_access_enabled = true
  tags                          = local.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}



