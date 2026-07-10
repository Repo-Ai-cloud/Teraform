# Lab Quality Standard

This standard defines what "community-ready" means for this course.

## Official Anchors

- [Current Terraform certification status](https://developer.hashicorp.com/certifications/infrastructure-automation)
- [Terraform Associate 004 preparation](https://developer.hashicorp.com/terraform/tutorials/certification-004)
- [Terraform Associate 004 objectives](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)
- [Terraform Associate 004 sample formats](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004)
- [Terraform dependency lock files](https://developer.hashicorp.com/terraform/language/files/dependency-lock)
- [Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/what-is-well-architected-framework)
- [Cloud Adoption Framework naming](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Cloud Adoption Framework tagging](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)
- [Azure Verified Modules](https://learn.microsoft.com/en-us/community/content/azure-verified-modules)

## Required Lesson Contract

- Exact objective IDs and a truthful `hands_on`, `guided`, or `conceptual` label.
- A lesson-specific scenario, walkthrough, expected result, failure mode, cleanup, and check questions.
- Reviewable, formatted configuration with explicit inputs and outputs.
- A committed root lock file for every external provider dependency and an intentional module version constraint.
- No real secrets, state, saved plans, private keys, local variable files, debug logs, or generated credentials.
- Meaningful Azure reliability, security, cost, operational, and performance discussion where applicable.
- An overview visual, a process diagram, and useful accessible descriptions that agree with the lab.

## Automated Acceptance

The quality gate must verify:

- Exactly 40 lessons and all required README sections/assets.
- All 37 official subobjectives with exact titles and at least one primary evidence mapping.
- Critical constructs in their mapped labs, including providers, data sources, dynamic blocks, modules, import/state operations, logging, and HCP integration examples.
- Exactly 60 original exam-style questions in the approved format distribution with complete objective coverage and rationales.
- `terraform fmt -check -recursive`, read-only initialization, validation, and checked-in Terraform tests.
- Repeatability on Terraform 1.12.0 and 1.15.8 without Azure or HCP credentials.
- Idempotence: consecutive full runs leave the Git worktree and committed locks unchanged.

## Manual Acceptance

- Azure backend bootstrap/migration and cleanup are smoke-tested in a disposable subscription.
- App Service, Container Apps, and other selected Azure plans use supported runtimes and expected SKUs.
- Optional HCP exercises demonstrate remote execution and managed state without requiring paid governance features.
- A facilitator can explain both the happy path and likely objections without inventing missing context.

## Review Levels

1. **Valid:** formats, initializes, validates, and tests.
2. **Objective-aligned:** evidence directly supports its mapped certification objective.
3. **Teachable:** expected behavior, failure, and recovery are clear.
4. **Azure-safe:** identity, state, cost, and cleanup decisions are defensible.
5. **Reference-worthy:** official anchors, visuals, assessment links, and current-version metadata are complete.
