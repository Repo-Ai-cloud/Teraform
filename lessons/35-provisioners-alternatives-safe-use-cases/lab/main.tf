locals {
  message = "Provisioners are a last resort. Prefer images, cloud-init, platform extensions, or managed services."
}

resource "local_file" "runbook" {
  filename = "${path.module}/generated-runbook.txt"
  content  = local.message
}

resource "terraform_data" "provisioner_decision" {
  input = {
    lesson_title   = "Provisioners, Alternatives, and Safe Use Cases"
    recommendation = local.message
  }
}



