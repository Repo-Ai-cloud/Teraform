output "lesson_summary" {
  description = "Computed values produced by this lesson."
  value       = terraform_data.lesson_contract.output
}
