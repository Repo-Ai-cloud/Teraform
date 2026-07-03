resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  storage_name = substr(lower(replace("${var.project_prefix}${var.environment}${var.workload_name}${random_string.suffix.result}", "-", "")), 0, 24)
  source_files = fileset(var.static_site_source_folder, "*")
  content_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
  }
  tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "31"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-static-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "site" {
  name                            = local.storage_name
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  tags                            = local.tags
}

resource "azurerm_storage_account_static_website" "site" {
  storage_account_id = azurerm_storage_account.site.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

resource "azurerm_storage_blob" "site_file" {
  for_each = local.source_files

  name                 = each.value
  storage_container_id = "${azurerm_storage_account.site.id}/blobServices/default/containers/$web"
  type                 = "Block"
  source               = "${var.static_site_source_folder}/${each.value}"
  content_type         = lookup(local.content_types, reverse(split(".", each.value))[0], "text/plain")

  depends_on = [azurerm_storage_account_static_website.site]
}




