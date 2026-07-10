mock_provider "random" {}

run "uses_the_constrained_external_provider" {
  command = plan

  assert {
    condition     = random_pet.provider_install.prefix == "atfa-dev"
    error_message = "The Random provider resource should use the normalized project and environment prefix."
  }
}
