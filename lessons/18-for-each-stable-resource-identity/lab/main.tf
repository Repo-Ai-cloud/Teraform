locals {
  regional_groups = {
    east = {
      location = var.location
      purpose  = "primary"
    }
    west = {
      location = "westus2"
      purpose  = "recovery"
    }
  }

  common_tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "18"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "regional" {
  for_each = local.regional_groups

  name     = "${var.project_prefix}-${var.environment}-${each.key}-${var.workload_name}-rg"
  location = each.value.location

  tags = merge(local.common_tags, {
    purpose = each.value.purpose
    region  = each.key
  })
}




