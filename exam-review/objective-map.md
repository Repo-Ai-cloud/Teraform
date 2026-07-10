# Terraform Associate 004 Objective Map

Verified **2026-07-10** against the [official Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004). The certification tests Terraform **1.12**. The course's “Azure Edition” label describes its teaching examples; Azure product trivia is not an exam objective.

Coverage labels are evidence levels, not difficulty ratings:

- **Hands-on** — the learner runs or changes an exercise that demonstrates the objective.
- **Guided** — the README provides a concrete procedure or comparison that may require an external account or service.
- **Conceptual** — the learner analyzes the feature without executing it.

The machine-readable source of exact titles is [`shared/quality/exam-objectives.json`](../shared/quality/exam-objectives.json); lesson evidence is recorded in [`course-map.yml`](../course-map.yml).

## 1. Infrastructure as Code (IaC) with Terraform

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 1a | Explain what IaC is | Lesson 01 — hands-on | — |
| 1b | Describe the advantages of IaC patterns | Lesson 01 — guided | Lesson 03 — guided |
| 1c | Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows | Lesson 01 — guided | — |

## 2. Terraform fundamentals

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 2a | Install and version Terraform providers | Lesson 05 — hands-on | Lessons 02 and 36 — conceptual/guided |
| 2b | Describe how Terraform uses providers | Lesson 05 — hands-on | Lessons 06 and 35 — hands-on |
| 2c | Write Terraform configuration using multiple providers | Lesson 30 — hands-on | Lessons 32 and 33 — hands-on |
| 2d | Explain how Terraform uses and manages state | Lesson 22 — hands-on | Lessons 14, 23, 24, and 25 |

## 3. Core Terraform workflow

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 3a | Describe the Terraform workflow | Lesson 04 — hands-on | Lessons 03 and 40 |
| 3b | Initialize a Terraform working directory | Lesson 04 — hands-on | Lessons 02 and 05 |
| 3c | Validate a Terraform configuration | Lesson 11 — hands-on | Lesson 04 — hands-on |
| 3d | Generate and review an execution plan for Terraform | Lesson 04 — hands-on | Lessons 03, 08, 30, and 40 |
| 3e | Apply changes to infrastructure with Terraform | Lesson 03 — hands-on | Lessons 30–35 |
| 3f | Destroy Terraform-managed infrastructure | Lesson 03 — hands-on | Lessons 30–34 |
| 3g | Apply formatting and style adjustments to a configuration | Lesson 04 — hands-on | Lesson 05 — hands-on |

## 4. Terraform configuration

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 4a | Use and differentiate `resource` and `data` blocks | Lesson 07 — hands-on | — |
| 4b | Refer to resource attributes and create cross-resource references | Lesson 07 — hands-on | Lessons 08 and 30–34 |
| 4c | Use variables and outputs | Lesson 09 — hands-on | Lessons 10, 14, and 34 |
| 4d | Understand and use complex types | Lesson 15 — hands-on | Lessons 16, 18, and 20 |
| 4e | Write dynamic configuration using expressions and functions | Lesson 20 — hands-on | Lessons 13, 16–18, and 21 |
| 4f | Define resource dependencies in configuration | Lesson 08 — hands-on | Lesson 19 — guided |
| 4g | Validate configuration using custom conditions | Lesson 11 — hands-on | — |
| 4h | Understand best practices for managing sensitive data, including secrets management with Vault | Lesson 12 — hands-on | Lesson 33 — guided Azure Key Vault comparison |

Objective 4h retains the official wording. Terraform 004 study also includes **ephemeral values** and **write-only arguments**; Lesson 12 treats those as additional topics rather than rewriting the official objective. HashiCorp Vault and Azure Key Vault are distinct products.

## 5. Terraform modules

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 5a | Explain how Terraform sources modules | Lesson 28 — hands-on | Lesson 29 — guided private-registry use |
| 5b | Describe variable scope within modules | Lesson 26 — hands-on | Lesson 27 — hands-on |
| 5c | Use modules in configuration | Lesson 26 — hands-on | Lesson 27 — hands-on |
| 5d | Manage module versions | Lesson 28 — hands-on | Lesson 29 — guided private-registry use |

## 6. Terraform state management

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 6a | Describe the local backend | Lesson 23 — hands-on | Lessons 22 and 25 |
| 6b | Describe state locking | Lesson 23 — hands-on | Lesson 22 — hands-on Azure backend |
| 6c | Configure remote state using the backend block | Lesson 22 — hands-on | — |
| 6d | Manage resource drift and Terraform state | Lesson 23 — hands-on | Lessons 19, 24, and 39 |

## 7. Maintain infrastructure with Terraform

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 7a | Import existing infrastructure into your Terraform workspace | Lesson 24 — hands-on | — |
| 7b | Use the CLI to inspect state | Lesson 24 — hands-on | — |
| 7c | Describe when and how to use verbose logging | Lesson 36 — hands-on | — |

## 8. HCP Terraform

| ID | Official objective | Primary evidence | Supporting evidence |
|---|---|---|---|
| 8a | Use HCP Terraform to create infrastructure | Lesson 37 — optional hands-on | — |
| 8b | Describe HCP Terraform collaboration and governance features | Lesson 37 — guided | Lessons 29 and 38 — guided; Lesson 39 — conceptual |
| 8c | Describe how to organize and use HCP Terraform workspaces and projects | Lesson 38 — optional hands-on | Lesson 39 — conceptual |
| 8d | Configure and use HCP Terraform integration | Lesson 37 — optional hands-on | Lesson 38 — optional hands-on |

The no-cost HCP workflow is optional because it requires an external account. Paid-tier policy and governance capabilities remain clearly labeled guided or conceptual coverage.
