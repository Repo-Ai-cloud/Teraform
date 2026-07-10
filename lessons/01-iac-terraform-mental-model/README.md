# Lesson 01: IaC and Terraform Mental Model

Azure is the teaching lens, not an official exam variant; provider-specific trivia is not tested.

## Certification alignment

- `1a` — Explain what IaC is — **hands-on**: The local terraform_data contract demonstrates declared intent; a guided comparison applies the same Terraform workflow to Azure, another cloud, on-premises systems, and SaaS APIs.
- `1b` — Describe the advantages of IaC patterns — **guided**: The local terraform_data contract demonstrates declared intent; a guided comparison applies the same Terraform workflow to Azure, another cloud, on-premises systems, and SaaS APIs.
- `1c` — Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows — **guided**: The local terraform_data contract demonstrates declared intent; a guided comparison applies the same Terraform workflow to Azure, another cloud, on-premises systems, and SaaS APIs.

## Scenario

A platform team is standardizing how short-lived event environments are requested and reviewed.

## Walkthrough

1. Read versions.tf, variables.tf, main.tf, and outputs.tf as a single desired-state contract.
2. Run the baseline commands, then optionally apply the built-in terraform_data resource and inspect the output.
3. Write a four-row comparison of manual changes versus reviewed Terraform changes, including one multi-cloud and one hybrid example.

Baseline commands for this lesson:

```powershell
Set-Location lab
terraform init -lockfile=readonly
terraform fmt -check
terraform validate
terraform plan
```

## Expected results

- The plan contains only the local terraform_data lesson contract.
- The output combines the chosen workload, environment, location, and tags.
- The comparison identifies providers as the service adapters while the core init-plan-apply workflow stays consistent.

## Failure modes

- Treating state as the desired configuration obscures the role of HCL.
- Assuming Terraform removes all provider-specific differences confuses a common workflow with identical APIs.
- Applying without reviewing the plan defeats a major IaC advantage.

## Wiki

![Lesson 01 visual](assets/lesson-01-visual.svg)
![Lesson 01 diagram](assets/lesson-01-diagram.svg)

## Cleanup

- If you applied the local contract, run terraform destroy before removing generated files.
- No Azure resource is created by this lesson.
- Remove generated `.terraform/`, plan files, state files, debug logs, copied `terraform.tfvars`, and generated secrets only after any required destroy or migration is complete.
- If this root has a committed `.terraform.lock.hcl`, keep it. Never delete a root lock file as routine cleanup; update it only during an intentional, reviewed dependency upgrade.
- Do not commit credentials, real secret values, state, plan files, backend credentials, or local variable files.

## Check questions

1. What makes configuration a better review artifact than a sequence of portal clicks?
2. Which part of the workflow remains stable when the provider changes?
3. How does state differ from desired configuration?

