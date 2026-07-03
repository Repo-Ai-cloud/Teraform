locals {
  workspace_environment = terraform.workspace == "default" ? var.environment : terraform.workspace
  workspace_name        = "${var.project_prefix}-${local.workspace_environment}-${var.workload_name}"
}

resource "terraform_data" "workspace_model" {
  input = {
    lesson_title = "Workspaces and Environment Separation"
    workspace    = terraform.workspace
    name         = local.workspace_name
  }
}



