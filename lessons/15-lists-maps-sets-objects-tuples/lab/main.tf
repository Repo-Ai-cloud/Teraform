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
    lesson              = "15"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title  = "Lists, Maps, Sets, Objects, and Tuples"
    service_tiers = var.service_tiers
    teams         = sort(tolist(var.team_contacts))
    labels        = [for name, units in var.service_tiers : "${name}-${units}"]
    tags          = local.common_tags
  }
}




