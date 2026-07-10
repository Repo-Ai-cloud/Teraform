mock_provider "random" {}

run "configures_an_importable_random_id" {
  command = plan

  assert {
    condition     = random_id.import_target.byte_length == 4
    error_message = "The state exercise requires a four-byte random_id compatible with the documented import ID."
  }

  assert {
    condition     = random_id.import_target.prefix == "atfa-dev-"
    error_message = "The root lab random_id should use the normalized project and environment prefix."
  }
}
