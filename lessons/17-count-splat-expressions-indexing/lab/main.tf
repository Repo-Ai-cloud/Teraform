resource "terraform_data" "lab_slot" {
  count = var.lab_slot_count

  input = {
    name        = format("%s-%s-slot-%02d", var.project_prefix, var.environment, count.index + 1)
    environment = var.environment
    region      = var.location
    index       = count.index
  }
}



