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
    scenario      = "A logical Random provider object is imported, inspected, renamed, and removed from state in a disposable directory."
    tags          = local.common_tags
  }
}

resource "random_id" "import_target" {
  byte_length = 4
  prefix      = "${local.normalized_prefix}-${local.environment}-"
}




