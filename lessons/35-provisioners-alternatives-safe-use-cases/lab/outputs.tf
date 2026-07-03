output "lesson_summary" {
  description = "Computed values produced by this lesson."
  value       = terraform_data.provisioner_decision.output
}
