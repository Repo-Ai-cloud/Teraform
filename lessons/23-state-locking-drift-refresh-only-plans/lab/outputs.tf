output "lesson_summary" {
  description = "Computed values produced by this lesson."
  value       = terraform_data.lesson_contract.output
}

output "drift_target_path" {
  description = "Path of the local file used by the disposable drift exercise."
  value       = local_file.drift_target.filename
}
