output "lesson_summary" {
  description = "Computed values produced by this lesson."
  value       = terraform_data.lesson_contract.output
}

output "subnet_cidr_blocks" {
  description = "Deterministic network allocations returned by the pinned public registry module."
  value       = module.subnet_plan.network_cidr_blocks
}
