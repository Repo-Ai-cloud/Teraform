output "lesson_summary" {
  description = "Computed values produced by this lesson."
  value       = terraform_data.workspace_model.output
}
