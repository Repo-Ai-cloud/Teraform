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
    lesson              = "39"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "Governance, Drift Detection, and Policy Concepts"
    governance_model = {
      policy_checks = ["required tags", "allowed regions", "approved resource types"]
      drift_detection = {
        health_assessment = true
        review_owner      = "platform-learning"
      }
      run_tasks = ["security scan", "cost estimate", "change evidence"]
      approvals = ["speculative plan review", "policy override review", "manual apply gate"]
    }
    tags = local.common_tags
  }
}




