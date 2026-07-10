output "lesson_summary" {
  description = "NSG and dynamically rendered rule names produced by this lesson."
  value = {
    network_security_group_name = azurerm_network_security_group.main.name
    rendered_rule_names         = [for rule in var.allowed_ingress_rules : rule.name]
  }
}
