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
    lesson              = "39"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "Governance, Drift Detection, and Policy Concepts"
    hcp_concepts = [
      "remote runs",
      "workspaces",
      "variable sets",
      "policy checks"
    ]
    tags = local.common_tags
  }
}



