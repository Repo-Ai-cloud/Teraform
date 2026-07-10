locals {
  common_tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "07"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

# A data source reads identity metadata that already exists in Azure. The
# resource below then references those values, forming an implicit dependency.
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-07-rg"
  location = var.location

  tags = merge(local.common_tags, {
    scenario        = "A reporting dashboard needs resources tied to the active Azure context."
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
  })
}




