# Lab Catalog

Use [`course-map.yml`](../course-map.yml) for machine-readable status, toolchain, lesson, and objective evidence. Coverage labels mean:

- `hands_on`: checked-in HCL or a repeatable command exercise directly demonstrates the objective.
- `guided`: the learner follows a documented workflow that may require Azure or HCP access.
- `conceptual`: the lesson explains and compares behavior without claiming a runnable service exercise.

## Foundation and Workflow — Lessons 01-08

IaC advantages, service-agnostic provider architecture, local tooling, core CLI workflow, external provider installation and lock files, Azure authentication, real resource/data-source references, and explicit dependency behavior.

## Terraform Configuration — Lessons 09-21

Variable definitions and precedence, custom conditions, sensitive versus ephemeral data, locals and outputs, structural types, transformations, repetition, lifecycle behavior, real dynamic Azure NSG blocks, and built-in functions.

## State and Modules — Lessons 22-29

Azure backend bootstrap and migration, local/remote locking and drift, refresh-only planning, state inspection and staged import/move/remove exercises, workspaces, local module composition, a real registry module, and guided private-registry concepts.

## Azure Implementations — Lessons 30-34

App Service on Node 24 LTS, Storage static content, Container Apps with an immutable demo image, Azure Key Vault with managed identity, and Log Analytics outputs. These reinforce Terraform behavior; Azure service trivia is not an exam objective.

## Operations, HCP Terraform, and Review — Lessons 35-40

Provisioner tradeoffs, safe logging and provider caching, optional HCP remote-run and two-workspace exercises, tier-aware governance/drift concepts, and two original 30-question practice sets.

Live Azure and HCP operations are always optional and excluded from pull-request CI.
