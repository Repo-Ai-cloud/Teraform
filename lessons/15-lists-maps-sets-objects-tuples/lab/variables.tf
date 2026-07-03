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


variable "service_tiers" {
  description = "Map of service tiers to capacity units."
  type        = map(number)
  default = {
    api    = 2
    worker = 1
    web    = 2
  }
}

variable "team_contacts" {
  description = "Set of teams that own the lab workload."
  type        = set(string)
  default     = ["platform", "support"]
}
