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
    lesson              = "05"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

# This logical provider does not need cloud credentials. Its installation is
# controlled by required_providers in versions.tf and recorded in the lock file
# when terraform init runs.
resource "random_pet" "provider_install" {
  length    = 2
  separator = "-"
  prefix    = "${local.normalized_prefix}-${local.environment}"
}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_number = "05"
    lesson_title  = "Providers, Version Constraints, and Lock Files"
    environment   = local.environment
    region        = var.location
    location      = var.location
    workload      = local.workload_name
    scenario      = "The team wants repeatable provider installation across laptops and CI."
    provider = {
      source        = "registry.terraform.io/hashicorp/random"
      generated_pet = random_pet.provider_install.id
    }
    tags = local.common_tags
  }
}




