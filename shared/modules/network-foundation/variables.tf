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

variable "location" {
  description = "Azure region."
  type        = string
}

variable "address_space" {
  description = "Virtual network address spaces."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Subnet prefixes keyed by subnet role."
  type        = map(string)
}
