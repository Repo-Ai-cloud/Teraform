# Architecture Review Checklist

Use this checklist before presenting, applying, or publishing a lab.

## Certification Evidence

- The lesson names exact Terraform Associate 004 objective IDs and labels each mapping as hands-on, guided, or conceptual.
- Hands-on claims point to real HCL, commands, or a repeatable exercise; conceptual coverage is not presented as a deployed lab.
- Terraform 1.12 behavior remains the exam baseline, while current-runtime notes are clearly separated.
- Azure is presented as the teaching context, not as an official exam variant or a body of provider trivia learners must memorize.

## Terraform Review

- `terraform fmt -check -recursive`, `terraform init -backend=false -lockfile=readonly`, `terraform validate`, and applicable `terraform test` commands pass.
- Every root module with an external provider has a reviewed `.terraform.lock.hcl`; child modules declare compatible minimums and do not own lock files.
- Provider and module version changes are intentional, dated, and reviewed with an execution plan.
- Data sources, dependencies, repeated-resource identities, lifecycle rules, and outputs match the stated learning objective.
- State, plans, variable files, credentials, debug logs, and `.terraform/` are absent from source control.
- Sensitive values are not mistaken for ephemeral values: redaction alone does not remove a value from state.

## Azure Review

- The selected subscription is disposable, the active tenant/subscription is shown before apply, and a budget alert exists.
- Required namespaces are registered before apply; the provider does not silently broaden registration permissions.
- Names respect Azure limits, while tags record environment, workload, owner, cost center, classification, criticality, and management method where supported.
- Authentication uses Azure CLI locally or workload identity/managed identity in automation; credentials are never embedded in HCL or backend files.
- Remote state uses Entra ID data-plane authorization, least privilege, private containers, and an explicit migration and recovery procedure.
- Cost-bearing resources use training settings and have tested cleanup and post-destroy verification.
- Runtime dependencies use supported versions or immutable image references.

## HCP Terraform Review

- Account-dependent steps are explicitly optional and do not run in pull-request CI.
- Workspace, project, variable-set, run-trigger, and managed-state responsibilities are distinct.
- Tokens come from `terraform login` or approved environment configuration and are never committed.
- Tier-dependent governance features are labeled as guided demonstrations unless the exercise can run on the free tier.
- The cleanup removes runs/workspaces and any optional Azure resources without deleting shared organizational configuration.

## Teaching Review

- The learner can predict the plan, explain the failure mode, and identify the cleanup path before apply.
- Commands show expected outcomes and include recovery guidance for authentication, locking, import, and version errors.
- Check questions assess the lesson's exact objective rather than repeat generic prompts.
- Diagrams and accessible descriptions agree with the implemented data flow.
