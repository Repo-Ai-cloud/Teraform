locals {
  common_tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "13"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-13-rg"
  location = var.location

  tags = merge(local.common_tags, {
    scenario = "A cost review team asks every Azure resource to "
  })
}




