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
    lesson              = "24"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_number = "24"
    lesson_title  = "State Inspection, Import, Moved, and Removed Blocks"
    environment   = local.environment
    region        = var.location
    location      = var.location
    workload      = local.workload_name
    scenario      = "An existing Azure resource group is being brought under Terraform management."
    tags          = local.common_tags
  }
}


# Example only: uncomment after a real refactor from the old address.
# moved {
#   from = terraform_data.old_name
#   to   = terraform_data.lesson_contract
# }



