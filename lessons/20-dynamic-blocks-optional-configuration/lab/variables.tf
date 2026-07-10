variable "project_prefix" {
  description = "Short lowercase prefix used in resource names."
  type        = string
  default     = "atfa"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,10}$", var.project_prefix))
    error_message = "Use 2 to 11 lowercase letters, numbers, or hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Environment label for the lab."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "Use one of: dev, test, stage, prod."
  }
}

variable "location" {
  description = "Azure region for labs that create Azure resources."
  type        = string
  default     = "eastus"
}

variable "workload_name" {
  description = "Short workload name used in examples."
  type        = string
  default     = "status"
}

variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider. Replace the placeholder before apply."
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "Use a subscription ID in GUID format."
  }
}

variable "allowed_ingress_rules" {
  description = "Rules rendered as nested security_rule blocks in the Azure NSG. Use an empty list to create an NSG without inbound allows."
  type = list(object({
    name                  = string
    priority              = number
    port                  = number
    protocol              = string
    source_address_prefix = string
    description           = optional(string, "Managed by Terraform")
  }))
  default = [
    {
      name                  = "https"
      priority              = 100
      port                  = 443
      protocol              = "Tcp"
      source_address_prefix = "Internet"
      description           = "Allow HTTPS for the training workload"
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.allowed_ingress_rules :
      rule.priority >= 100 && rule.priority <= 4096 && rule.port >= 1 && rule.port <= 65535
    ])
    error_message = "Each rule priority must be 100-4096 and each port must be 1-65535."
  }

  validation {
    condition     = length(distinct([for rule in var.allowed_ingress_rules : rule.priority])) == length(var.allowed_ingress_rules)
    error_message = "Each NSG rule must use a unique priority."
  }
}
