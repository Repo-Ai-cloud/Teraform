locals {
  tags = {
    course      = "certified-terraform-associate-azure-edition"
    managed_by  = "terraform"
    lesson      = "22"
    purpose     = "terraform-state"
    environment = var.environment
  }

  backend_principal_object_id = coalesce(var.backend_principal_object_id, data.azurerm_client_config.current.object_id)
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "state" {
  name     = "${var.project_prefix}-${var.environment}-tfstate-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "state" {
  name                = var.backend_storage_account_name
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location

  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  default_to_oauth_authentication  = true
  public_network_access_enabled    = true
  shared_access_key_enabled        = false
  cross_tenant_replication_enabled = false

  blob_properties {
    versioning_enabled = true
  }

  tags = local.tags
}

resource "azurerm_storage_container" "state" {
  name                  = var.backend_container_name
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

# Scope the data-plane role to this container rather than the subscription or
# resource group. The caller still needs permission to create role assignments.
resource "azurerm_role_assignment" "state_blob_data" {
  scope                = azurerm_storage_container.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.backend_principal_object_id
  principal_type       = var.backend_principal_type
}
