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
    lesson              = "23"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_number = "23"
    lesson_title  = "State Locking, Drift, and Refresh-Only Plans"
    environment   = local.environment
    region        = var.location
    location      = var.location
    workload      = local.workload_name
    scenario      = "A dashboard tag was changed in the portal and the team wants to inspect drift before changing anything."
    tags          = local.common_tags
  }
}

# Apply this resource in the lesson's disposable demo directory, edit the file
# outside Terraform, and run a normal or refresh-only plan to observe drift.
resource "local_file" "drift_target" {
  filename        = "${path.root}/generated/drift-demo.txt"
  content         = var.drift_message
  file_permission = "0644"
}




