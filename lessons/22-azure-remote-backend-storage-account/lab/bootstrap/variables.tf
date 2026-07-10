variable "project_prefix" {
  description = "Short lowercase prefix used in state infrastructure names."
  type        = string
  default     = "atfa"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,10}$", var.project_prefix))
    error_message = "Use 2 to 11 lowercase letters, numbers, or hyphens, starting with a letter."
  }
}

variable "environment" {
  description = "Environment label used for the state infrastructure."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "Use one of: dev, test, stage, prod."
  }
}

variable "location" {
  description = "Azure region for the state storage account."
  type        = string
  default     = "eastus"
}

variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "Use a subscription ID in GUID format."
  }
}

variable "backend_storage_account_name" {
  description = "Globally unique Azure Storage account name (3-24 lowercase alphanumeric characters)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.backend_storage_account_name))
    error_message = "Use 3-24 lowercase letters or numbers."
  }
}

variable "backend_container_name" {
  description = "Private blob container that stores Terraform state."
  type        = string
  default     = "tfstate"

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])?$", var.backend_container_name))
    error_message = "Use a valid lowercase Azure Storage container name."
  }
}

variable "backend_principal_object_id" {
  description = "Optional object ID that receives blob-data access. Null selects the current Azure CLI principal."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.backend_principal_object_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.backend_principal_object_id))
    error_message = "Use null or a principal object ID in GUID format."
  }
}

variable "backend_principal_type" {
  description = "Principal type for the role assignment. Choose User for an interactive Azure CLI lab or ServicePrincipal for automation."
  type        = string
  default     = "User"

  validation {
    condition     = contains(["User", "ServicePrincipal"], var.backend_principal_type)
    error_message = "Use User or ServicePrincipal."
  }
}
