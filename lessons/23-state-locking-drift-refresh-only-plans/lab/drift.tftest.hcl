mock_provider "local" {}

run "plans_the_expected_local_file" {
  command = plan

  assert {
    condition     = local_file.drift_target.content == "managed by Terraform - lesson 23"
    error_message = "The local drift target must start with Terraform-managed content."
  }

  assert {
    condition     = endswith(local_file.drift_target.filename, "generated/drift-demo.txt")
    error_message = "The drift target must stay inside the disposable working directory."
  }
}
