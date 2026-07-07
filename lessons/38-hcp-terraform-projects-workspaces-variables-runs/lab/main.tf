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
    lesson              = "38"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "HCP Terraform Projects, Workspaces, Variables, and Runs"
    hcp_project  = "${local.normalized_prefix}-${local.environment}-platform"
    workspaces = {
      network = {
        purpose      = "shared Azure foundation"
        execution    = "remote"
        run_triggers = ["app"]
      }
      app = {
        purpose      = "application deployment"
        execution    = "remote"
        run_triggers = []
      }
    }
    variable_sets = {
      azure_training_defaults = ["ARM_TENANT_ID", "ARM_SUBSCRIPTION_ID", "location"]
      shared_tags             = ["owner", "cost_center", "data_classification"]
    }
    tags = local.common_tags
  }
}




