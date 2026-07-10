locals {
  common_tags = {
    course      = "certified-terraform-associate-azure-edition"
    managed_by  = "terraform"
    lesson      = "20"
    environment = var.environment
    workload    = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-20-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.project_prefix}-${var.environment}-${var.workload_name}-20-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = { for rule in var.allowed_ingress_rules : rule.name => rule }

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value.port)
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}



