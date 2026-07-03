module "naming" {
  source = "../../../shared/modules/naming"

  project_prefix = var.project_prefix
  environment    = var.environment
  workload_name  = var.workload_name
  suffix         = "26"
}

resource "terraform_data" "module_scope" {
  input = {
    lesson_title = "Local Modules and Variable Scope"
    names        = module.naming.names
    tags         = module.naming.tags
  }
}



