output "secret_handling_summary" {
  description = "Shows metadata without revealing the sensitive token."
  value = {
    lesson_title      = terraform_data.lesson_contract.output.lesson_title
    vault_secret_path = terraform_data.lesson_contract.output.vault_secret_path
    secret_controls   = terraform_data.lesson_contract.output.secret_controls
    tags              = terraform_data.lesson_contract.output.tags
  }
}

output "state_backed_secret" {
  description = "Intentionally sensitive output: redacted in the CLI, but still present in state for comparison with ephemeral values."
  value       = terraform_data.state_backed_secret.output.api_token
  sensitive   = true
}
