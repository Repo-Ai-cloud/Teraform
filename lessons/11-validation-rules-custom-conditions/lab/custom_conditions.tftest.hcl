run "valid_custom_conditions" {
  command = plan

  assert {
    condition     = terraform_data.lesson_contract.input.approved_region
    error_message = "The default region should satisfy variable validation, lifecycle conditions, and the check block."
  }
}

run "requested_region_rejected" {
  command = plan

  variables {
    location        = "centralus"
    allowed_regions = ["eastus"]
  }

  expect_failures = [
    check.requested_region_is_allowed,
  ]
}

run "unsupported_allowlist_rejected" {
  command = plan

  variables {
    allowed_regions = ["moonbase"]
  }

  expect_failures = [
    terraform_data.lesson_contract,
    check.requested_region_is_allowed,
  ]
}
