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
    lesson              = "37"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "HCP Terraform Workflow Overview"
    local_workflow = {
      state_location = "local or configured backend"
      run_location   = "operator workstation"
      approval_gate  = "team process outside Terraform"
    }
    hcp_terraform_workflow = {
      state_location = "HCP Terraform managed state"
      run_location   = "remote operations"
      included_stages = [
        "configuration upload",
        "remote plan",
        "manual confirmation",
        "remote apply",
        "managed state version"
      ]
      optional_governance = ["policy checks", "run tasks"]
      integration         = ["terraform login", "cloud block", "CLI-driven workflow", "VCS-driven workflow"]
    }
    tags = local.common_tags
  }
}




