# Azure Safety and Cost Guardrails

These labs are written for training subscriptions, not production subscriptions.

## Subscription Guardrails

- Use a disposable or sandbox subscription.
- Set a budget alert before running cloud-resource lessons.
- Prefer a dedicated resource group per lab so cleanup is easy to verify.
- Do not run labs with an owner-level identity if contributor-level permissions are sufficient.
- Review regional availability before applying a service-specific lab.

## State and Secret Guardrails

- Do not commit `terraform.tfvars`, state files, plan files, private keys, generated credentials, or `.terraform/`.
- Treat state as sensitive because providers can store values that were not obvious from the configuration.
- Use environment variables, workload identity, managed identity, HCP Terraform variables, or a secret store for real credentials.
- Keep backend configuration values out of source control when they identify private environments.

## Cost Guardrails

- Run `terraform plan` before `terraform apply`.
- Prefer low-cost SKUs in labs and document why a more expensive SKU is required.
- Destroy resources immediately after completing a lab.
- Confirm cleanup in the Azure portal, Azure CLI, or Resource Graph if the lab created billable services.
- Watch for resources that continue billing after dependencies are removed, such as logs, public IPs, disks, and storage.
