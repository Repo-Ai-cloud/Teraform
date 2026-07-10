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
    vault_secret_path = var.vault_secret_path
    secret_controls = [
      "sensitive redacts CLI output but does not remove values from state",
      "ephemeral values are omitted from plan and state",
      "HashiCorp Vault and Azure Key Vault are different products",
      "write-only provider arguments accept ephemeral values without persisting them"
    ]
    tags = local.common_tags
  }
}

# This intentionally demonstrates the risk: sensitive values are redacted in
# normal CLI output, but a managed resource argument is still persisted in state.
# Use only the throwaway default or another non-production value in this lab.
resource "terraform_data" "state_backed_secret" {
  input = {
    api_token = var.api_token
  }
}

# Unlike the managed Random resource, this value exists only for the current
# operation. It never appears in a plan file or Terraform state. A real system
# would pass it to a provider configuration or a write-only (*_wo) argument.
ephemeral "random_password" "transient" {
  length           = 24
  special          = true
  override_special = "!#$%&*+-=?@^_"
}




