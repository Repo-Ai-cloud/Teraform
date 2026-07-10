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
    lesson              = "29"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_number = "29"
    lesson_title  = "Private Module Registry Concepts"
    environment   = local.environment
    region        = var.location
    location      = var.location
    workload      = local.workload_name
    scenario      = "An organization publishes versioned golden modules in its private HCP Terraform registry."
    module_source = "app.terraform.io/example-organization/azure-workload/azurerm"
    authentication = {
      command            = "terraform login app.terraform.io"
      token_in_source    = false
      token_in_tfvars    = false
      credential_storage = "Terraform CLI credentials file"
    }
    tags = local.common_tags
  }
}




