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

variable "api_token" {
  description = "Example secret value. Use a throwaway value in local labs and a secret store in real workflows."
  type        = string
  sensitive   = true
  default     = "replace-with-lab-only-token"
}

variable "transient_session_token" {
  description = "Example ephemeral value for provider authentication or write-only arguments. It is intentionally not stored in this lab's state-backed resources."
  type        = string
  sensitive   = true
  ephemeral   = true
  default     = null
}

variable "vault_secret_path" {
  description = "Example Vault path that would identify where a real workflow retrieves a secret without committing it."
  type        = string
  default     = "kv/data/training/terraform-associate"
}
