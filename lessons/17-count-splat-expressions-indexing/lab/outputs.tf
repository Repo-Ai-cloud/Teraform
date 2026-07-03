output "slot_names" {
  description = "Names generated with count and returned with a splat expression."
  value       = terraform_data.lab_slot[*].output.name
}
