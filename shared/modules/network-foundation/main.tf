locals {
  base_name = "${var.project_prefix}-${var.environment}-${var.workload_name}"

  tags = {
    environment         = var.environment
    workload            = var.workload_name
    region              = var.location
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
  }
}

resource "azurerm_resource_group" "network" {
  name     = "${local.base_name}-network-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${local.base_name}-vnet"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.address_space
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnet_prefixes

  name                 = "${each.key}-snet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value]
}
