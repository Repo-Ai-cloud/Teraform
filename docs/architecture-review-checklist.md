# Architecture Review Checklist

Use this checklist before presenting, applying, or publishing any lab.

## Terraform Review

- The lab has `versions.tf`, `variables.tf`, `main.tf`, `outputs.tf`, and `terraform.tfvars.example` unless the lesson has a documented reason to differ.
- `terraform fmt -check -recursive` passes.
- `terraform init -backend=false -input=false` and `terraform validate` pass.
- Provider and module versions are pinned with intentional constraints.
- Outputs do not expose secrets or unnecessary sensitive implementation details.
- Resource addresses are stable when repeated resources have meaningful identity.

## Azure Review

- Names use stable identifiers and respect Azure naming limits.
- Tags or metadata cover environment, workload, owner, cost center, data classification, criticality, and management method where the resource supports tags.
- The lab can be applied in a disposable subscription without requiring production permissions.
- Cost-bearing resources use low-cost lab settings and have an explicit cleanup step.
- Identity and secret patterns prefer managed identity, RBAC, and external secret stores over embedded credentials.
- Monitoring, diagnostics, or operational handoff details are discussed when the resource type makes that relevant.

## Teaching Review

- The scenario is concrete enough for a learner to remember.
- The learner can explain what the plan is expected to create, change, or destroy.
- The README includes an extension challenge that does not require copying from another lesson.
- The cleanup path is tested or mechanically obvious.
- The lesson references the relevant course standard instead of relying on tribal knowledge.
