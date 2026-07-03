locals {
  normalized_prefix = lower(replace(var.project_prefix, " ", "-"))
  environment       = lower(var.environment)
  workload_name     = lower(replace(var.workload_name, " ", "-"))

  common_tags = {
    course              = "azure-terraform-associate-40-labs"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "11"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }


  supported_regions = ["eastus", "eastus2", "westus2", "westeurope"]
}

resource "terraform_data" "lesson_contract" {
  input = {
    approved_region = contains(var.allowed_regions, var.location)
    requested       = var.location
    lesson_title    = "Validation Rules and Custom Conditions"
    tags            = local.common_tags
  }
}



