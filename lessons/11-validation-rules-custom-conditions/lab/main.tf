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
    lesson              = "11"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }


  supported_regions = ["eastus", "eastus2", "westus2", "westeurope"]
}

resource "terraform_data" "lesson_contract" {
  input = {
    approved_region = contains(var.allowed_regions, var.location)
    requested       = var.location
    lesson_title    = "Validation Rules and Custom Conditions"
    tags            = local.common_tags
  }

  lifecycle {
    precondition {
      condition     = length(setsubtract(var.allowed_regions, toset(local.supported_regions))) == 0
      error_message = "Allowed regions must stay inside the supported training-region list."
    }

    postcondition {
      condition     = self.output.approved_region == true
      error_message = "The requested location must be included in allowed_regions."
    }
  }
}

check "requested_region_is_allowed" {
  assert {
    condition     = contains(var.allowed_regions, var.location)
    error_message = "The requested Azure region is outside the approved training account list."
  }
}



