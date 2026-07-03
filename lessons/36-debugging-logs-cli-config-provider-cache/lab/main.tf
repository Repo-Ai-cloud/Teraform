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
    lesson              = "36"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "Debugging, Logs, CLI Config, and Provider Cache"
    debug_steps = [
      "Set TF_LOG only for focused troubleshooting.",
      "Use a plugin cache for repeated CI runs.",
      "Remove local logs before sharing support bundles."
    ]
    tags = local.common_tags
  }
}




