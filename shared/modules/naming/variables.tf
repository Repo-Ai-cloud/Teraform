variable "project_prefix" {
  description = "Short project prefix."
  type        = string
}

variable "environment" {
  description = "Environment label."
  type        = string
}

variable "workload_name" {
  description = "Workload label."
  type        = string
}

variable "suffix" {
  description = "Optional suffix for resource names."
  type        = string
  default     = ""
}
