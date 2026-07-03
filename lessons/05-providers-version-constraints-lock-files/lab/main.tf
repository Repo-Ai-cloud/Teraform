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
    lesson              = "05"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_number = "05"
    lesson_title  = "Providers, Version Constraints, and Lock Files"
    environment   = local.environment
    region        = var.location
    location      = var.location
    workload      = local.workload_name
    scenario      = "The team wants repeatable provider installation across laptops and CI."
    tags          = local.common_tags
  }
}



