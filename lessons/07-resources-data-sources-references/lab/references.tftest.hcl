mock_provider "azurerm" {
  override_during = plan

  mock_data "azurerm_client_config" {
    defaults = {
      client_id       = "11111111-1111-1111-1111-111111111111"
      object_id       = "22222222-2222-2222-2222-222222222222"
      subscription_id = "33333333-3333-3333-3333-333333333333"
      tenant_id       = "44444444-4444-4444-4444-444444444444"
    }
  }
}

run "data_source_values_flow_into_resource" {
  command = plan

  assert {
    condition     = azurerm_resource_group.main.tags["subscription_id"] == "33333333-3333-3333-3333-333333333333"
    error_message = "The managed resource must reference the mocked subscription data source."
  }

  assert {
    condition     = output.active_azure_context.tenant_id == "44444444-4444-4444-4444-444444444444"
    error_message = "The output must expose the non-secret tenant identifier read by the data source."
  }
}
