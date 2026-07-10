# Azure Safety and Cost Guardrails

These labs target disposable training subscriptions, never production subscriptions.

## Subscription and Identity Guardrails

- Run `az account show` before every live plan and stop if the tenant or subscription is unexpected.
- Use Contributor only where a lab needs it; assign Storage Blob Data Contributor separately for Azure backend data-plane access.
- Prefer Azure CLI authentication locally and workload identity or managed identity in automation. Do not create long-lived client secrets for a lesson.
- Use a dedicated resource group per applied lab and set a budget alert before creating resources.
- Confirm regional availability, quotas, and policy restrictions before applying service-specific lessons.

The AzureRM examples set `resource_provider_registrations = "none"` so Terraform does not register namespaces implicitly. Register only what the selected lessons require:

```powershell
$namespaces = @(
  "Microsoft.App",
  "Microsoft.KeyVault",
  "Microsoft.ManagedIdentity",
  "Microsoft.Network",
  "Microsoft.OperationalInsights",
  "Microsoft.Storage",
  "Microsoft.Web"
)

$namespaces | ForEach-Object { az provider register --namespace $_ }
```

Use `./shared/scripts/Test-CourseEnvironment.ps1 -Profile Supported -RequireAzureLogin` for the repository's read-only preflight. Registration commands are intentionally separate because they change the subscription.

## State, Locks, and Secrets

- Commit root-module `.terraform.lock.hcl` files; they record provider selections and checksums, not credentials.
- Do not commit state, saved plans, `terraform.tfvars`, backend files for private environments, credentials, private keys, debug logs, or `.terraform/`.
- Treat state and saved plans as sensitive even when terminal output redacts a value.
- Use HashiCorp Vault, Azure Key Vault, HCP sensitive variables, or another approved secret system. Azure Key Vault is an Azure example, not a substitute term for HashiCorp Vault in objective 4h.
- Prefer ephemeral values and provider write-only arguments only where Terraform and the provider explicitly support them.

## Backend Guardrails

- Bootstrap the Azure Storage account and container before migrating a workload to the backend.
- Use Entra ID data-plane authentication (`use_azuread_auth = true`) and avoid storage account keys in backend configuration.
- Review `terraform init -migrate-state` prompts and keep a recoverable copy until the migrated state is verified.
- Destroy workloads before tearing down the backend. Never delete a container that still owns active state.

## Cost and Cleanup Guardrails

- Run and review `terraform plan` before every apply; stop on unexpected replacement or destroy actions.
- Use low-cost SKUs, short retention, and immutable demo images where the lesson supports them.
- Destroy resources immediately after the exercise and confirm deletion through Azure CLI, the portal, or Resource Graph.
- Check for retained logs, public IPs, disks, storage, and soft-deleted vaults after dependent resources disappear.
- Never automate live Azure or HCP apply/destroy in pull-request validation.
