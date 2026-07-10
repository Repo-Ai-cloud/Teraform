run "pinned_module_calculates_expected_subnets" {
  command = plan

  assert {
    condition     = output.subnet_cidr_blocks["web"] == "10.42.0.0/24"
    error_message = "The pinned module should allocate the first /24 to the web subnet."
  }

  assert {
    condition     = output.subnet_cidr_blocks["application"] == "10.42.1.0/24"
    error_message = "The pinned module should allocate the second /24 to the application subnet."
  }

  assert {
    condition     = output.subnet_cidr_blocks["data"] == "10.42.2.0/24"
    error_message = "The pinned module should allocate the third /24 to the data subnet."
  }
}
