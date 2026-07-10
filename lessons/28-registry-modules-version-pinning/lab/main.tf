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
    lesson              = "28"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

# This public registry module is intentionally active and exactly pinned. It
# has no providers and performs only deterministic CIDR calculations.
module "subnet_plan" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = "10.42.0.0/16"
  networks = [
    {
      name     = "web"
      new_bits = 8
    },
    {
      name     = "application"
      new_bits = 8
    },
    {
      name     = "data"
      new_bits = 8
    }
  ]
}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "Registry Modules and Version Pinning"
    active_module = {
      source  = "hashicorp/subnets/cidr"
      version = "1.0.0"
    }
    azure_module_review = {
      source  = "Azure/avm-res-network-virtualnetwork/azurerm"
      version = "~> 0.19"
    }
    adoption_note = "Review inputs, outputs, dependencies, license, and upgrade notes before use."
    tags          = local.common_tags
  }
}




