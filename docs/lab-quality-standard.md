# Lab Quality Standard

This standard defines what "community-ready" means for this course. A lab should teach Terraform clearly while modeling the professional Azure habits an experienced instructor would be comfortable demonstrating in public.

## Official Anchors

- Terraform Associate 004 objectives: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004
- Terraform on Azure documentation: https://learn.microsoft.com/en-us/azure/developer/terraform/
- Azure Well-Architected Framework: https://learn.microsoft.com/en-us/azure/well-architected/what-is-well-architected-framework
- Cloud Adoption Framework naming: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
- Cloud Adoption Framework tagging: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging
- Azure Verified Modules: https://learn.microsoft.com/en-us/community/content/azure-verified-modules
- Terraform compliance testing on Azure: https://learn.microsoft.com/en-us/azure/developer/terraform/azurerm/best-practices-compliance-testing

## Lab Acceptance Criteria

- Learning intent is explicit: the learner can state the Terraform objective and the Azure operating habit.
- Configuration is reviewable: files are small, named predictably, formatted, and validated.
- Design tradeoffs are visible: each lesson calls out at least one Well-Architected lens.
- Naming and tags are intentional: stable values appear in names; mutable ownership, cost, and classification data appear in tags or metadata.
- Safety is built in: no real secrets, no state files, no private keys, no hidden apply step, and cleanup is documented.
- Validation is automated: `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and course hygiene checks pass.
- Facilitation is ready: a speaker can explain the scenario, expected plan, cleanup, and extension challenge without inventing missing context.

## Well-Architected Prompts

- Reliability: What dependency, state, or recovery behavior matters for this lab?
- Security: What identity, secret, network, or least-privilege choice is visible?
- Cost Optimization: What resource SKU, retention setting, or cleanup step controls spend?
- Operational Excellence: What can be observed, reviewed, repeated, and automated?
- Performance Efficiency: What scale, latency, or service-fit tradeoff would matter beyond the lab?

## Instructor Review Levels

- Level 1, Valid: Terraform initializes, formats, and validates.
- Level 2, Teachable: the README explains the why, not only the commands.
- Level 3, Azure-ready: design notes reflect Azure naming, tagging, security, and cost controls.
- Level 4, Community-ready: a facilitator can present it live and answer the likely objections.
- Level 5, Reference-worthy: the lab links to official guidance and includes an extension path.

