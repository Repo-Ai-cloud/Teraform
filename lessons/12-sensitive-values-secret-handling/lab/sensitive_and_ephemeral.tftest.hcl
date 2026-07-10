# Terraform's mocking framework does not support ephemeral resource types yet.
# The Random provider is credential-free, so this test safely uses it directly.
provider "random" {}

run "sensitive_value_is_still_a_managed_resource_argument" {
  command = plan

  variables {
    api_token = "throwaway-test-token"
  }

  assert {
    condition     = terraform_data.state_backed_secret.input.api_token == "throwaway-test-token"
    error_message = "Marking a variable sensitive must not be mistaken for omitting it from managed resource state."
  }
}
