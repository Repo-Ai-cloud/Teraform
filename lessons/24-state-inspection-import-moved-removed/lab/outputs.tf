output "lesson_summary" {
  description = "Computed values produced by this lesson."
  value       = terraform_data.lesson_contract.output
}

output "random_id_import_target" {
  description = "Import-capable logical resource used by the disposable state exercise."
  value = {
    address = "random_id.import_target"
    id      = random_id.import_target.id
    hex     = random_id.import_target.hex
  }
}
