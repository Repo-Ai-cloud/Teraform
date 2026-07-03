locals {
  normalized_prefix = lower(replace(var.project_prefix, " ", "-"))
  environment       = lower(var.environment)
  workload_name     = lower(replace(var.workload_name, " ", "-"))

  common_tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "28"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title       = "Registry Modules and Version Pinning"
    example_source     = "Azure/avm-res-network-virtualnetwork/azurerm"
    version_constraint = "~> 0.8"
    adoption_note      = "Review inputs, outputs, license, and upgrade notes before use."
    tags               = local.common_tags
  }
}




