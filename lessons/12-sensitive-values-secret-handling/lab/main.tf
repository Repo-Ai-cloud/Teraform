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
    lesson              = "12"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title      = "Sensitive Values and Secret Handling"
    secret_is_present = length(var.api_token) > 0
    secret_preview    = sensitive(substr(var.api_token, 0, 0))
    vault_secret_path = var.vault_secret_path
    secret_controls = [
      "sensitive input variables",
      "Vault or another secret manager",
      "ephemeral values for transient credentials",
      "write-only provider arguments when available"
    ]
    tags = local.common_tags
  }
}




