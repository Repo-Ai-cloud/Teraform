locals {
  rendered_rules = [
    for rule in var.allowed_ingress_rules : {
      label = "${var.project_prefix}-${var.environment}-${rule.name}"
      port  = rule.port
    }
  ]
}

resource "terraform_data" "network_review" {
  input = {
    lesson_title = "Dynamic Blocks and Optional Configuration"
    rules        = local.rendered_rules
  }
}



