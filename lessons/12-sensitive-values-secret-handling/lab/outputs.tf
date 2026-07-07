output "secret_handling_summary" {
  description = "Shows metadata without revealing the sensitive token."
  value = {
    lesson_title      = terraform_data.lesson_contract.output.lesson_title
    secret_is_present = terraform_data.lesson_contract.output.secret_is_present
    vault_secret_path = terraform_data.lesson_contract.output.vault_secret_path
    secret_controls   = terraform_data.lesson_contract.output.secret_controls
    tags              = terraform_data.lesson_contract.output.tags
  }
}
