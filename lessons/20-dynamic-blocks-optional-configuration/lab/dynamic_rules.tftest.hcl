mock_provider "azurerm" {}

run "renders_one_nested_rule_per_input" {
  command = plan

  variables {
    allowed_ingress_rules = [
      {
        name                  = "https"
        priority              = 100
        port                  = 443
        protocol              = "Tcp"
        source_address_prefix = "Internet"
        description           = "Public TLS"
      },
      {
        name                  = "health"
        priority              = 110
        port                  = 8080
        protocol              = "Tcp"
        source_address_prefix = "AzureLoadBalancer"
        description           = "Load balancer probe"
      }
    ]
  }

  assert {
    condition     = length(azurerm_network_security_group.main.security_rule) == 2
    error_message = "The dynamic block must create one security_rule block for each input rule."
  }

  assert {
    condition     = toset([for rule in azurerm_network_security_group.main.security_rule : rule.name]) == toset(["health", "https"])
    error_message = "The rendered NSG rules must preserve the configured rule names."
  }
}
