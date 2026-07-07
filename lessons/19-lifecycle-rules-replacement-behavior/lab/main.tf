locals {
  common_tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "19"
    environment         = var.environment
    region              = var.location
    workload            = var.workload_name
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_prefix}-${var.environment}-${var.workload_name}-19-rg"
  location = var.location

  tags = merge(local.common_tags, {
    scenario = "A status page must keep a stable resource group "
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags["portal-note"]]
  }

}

resource "terraform_data" "replacement_marker" {
  input = {
    release_track = "${var.environment}-${var.workload_name}"
    review_note   = "This local marker models replacement ordering without forcing an Azure resource replacement."
  }

  lifecycle {
    create_before_destroy = true
  }
}



