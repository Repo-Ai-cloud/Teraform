locals {
  safe_name    = substr(lower(replace("${var.project_prefix}-${var.environment}-${var.workload_name}", "-", "")), 0, 20)
  subnet_names = ["web", "api", "data"]
  subnets = {
    for index, name in local.subnet_names : name => cidrsubnet(var.address_space, 8, index)
  }
}

resource "terraform_data" "naming_and_cidr" {
  input = {
    lesson_title = "Built-in Functions for Azure Naming and CIDR Work"
    safe_name    = local.safe_name
    subnets      = local.subnets
  }
}



