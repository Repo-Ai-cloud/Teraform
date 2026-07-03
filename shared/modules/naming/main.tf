locals {
  compact_parts = compact([
    lower(var.project_prefix),
    lower(var.environment),
    lower(var.workload_name),
    lower(var.suffix)
  ])

  base_name = join("-", local.compact_parts)

  names = {
    resource_group = "${local.base_name}-rg"
    app_service    = replace("${local.base_name}-app", "-", "")
    storage        = substr(replace("${local.base_name}st", "-", ""), 0, 24)
  }

  tags = {
    environment         = var.environment
    workload            = var.workload_name
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
  }
}
