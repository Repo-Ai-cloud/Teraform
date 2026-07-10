# Manual Cloud Smoke Tests

These checks are excluded from pull-request CI. Run them only in a disposable subscription or optional HCP account after the local quality gate passes.

## Common Preflight

```powershell
./shared/scripts/Test-CourseEnvironment.ps1 -Profile Supported -RequireAzureLogin
az account show --output table
```

Confirm the tenant/subscription, budget alert, required resource-provider registrations, region availability, and cleanup owner before continuing. Never paste credentials into `.tf`, `.tfvars`, backend configuration, or terminal transcripts.

## Lesson 22 — Azure Backend

1. Apply the bootstrap root with local state and capture its resource group, account, and container outputs.
2. Grant the operator Storage Blob Data Contributor on the container/account scope and wait for propagation.
3. Populate a private `backend.hcl` from the example using `use_azuread_auth = true` and CLI authentication.
4. In the workload root, run `terraform init -migrate-state -backend-config=backend.hcl`, inspect the prompt, and confirm the blob exists.
5. Run a no-change plan, verify state locking with a second operation, and inspect state without downloading or publishing it.
6. Destroy the workload, migrate or deliberately discard its state, and only then destroy the bootstrap resources.

## Lesson 30 — App Service

1. Confirm the plan selects the low-cost training SKU, a managed identity, and Node `24-lts`.
2. Apply, open the default endpoint, and verify the web app reports healthy.
3. Run a second plan and require no changes.
4. Destroy and confirm the resource group and app hostname are gone.

## Lesson 32 — Container Apps

1. Confirm the plan uses the checked-in immutable `mcr.microsoft.com/k8se/quickstart` digest.
2. Apply, request the application FQDN, and record only non-sensitive health evidence.
3. Run a second plan and require no image drift.
4. Destroy the app/environment and check that Log Analytics or other dependencies are not retained.

## Lessons 37-39 — Optional HCP Terraform

1. Use `terraform login` and create the documented project/workspaces on the free tier.
2. Copy each `cloud.tf.example` to its ignored local filename and replace organization/workspace placeholders.
3. Run the no-cost upstream configuration remotely; verify run stages, outputs, managed state, and history.
4. Configure the downstream workspace, permitted remote-state output access, shared variable set, and run trigger.
5. Change the upstream input, confirm the downstream trigger, and explain which data crossed the workspace boundary.
6. Review tier-labeled health, drift, policy, run-task, and approval screens without enabling paid features.
7. Destroy any managed objects, remove the exercise workspaces, and run `terraform logout` if the workstation should not retain the token.

The optional Azure extension may create one resource group through HCP dynamic Azure credentials. It requires workload-identity setup, a reviewed plan, immediate destroy, and verification that no role assignment or federated credential was left behind.
