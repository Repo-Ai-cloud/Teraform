# Certified Terraform Associate: Azure Edition

An original Azure-focused study course for the HashiCorp Terraform Associate 004 exam. The repo teaches Terraform fundamentals through small, reviewable Azure scenarios, local-first exercises, lesson wikis, diagrams, and automated quality checks.

Official objective reference: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004

![Lesson 01 visual](lessons/01-iac-terraform-mental-model/assets/lesson-01-visual.svg)

## What This Course Is

This course is built for learners who want Terraform exam preparation that still feels close to real Azure work. It does not try to turn the Terraform Associate exam into an Azure trivia test. Instead, each lesson teaches a Terraform concept, then anchors that concept in practical Azure operating habits: naming, tagging, plan review, state safety, cleanup, and cost awareness.

The course contains 40 lessons. Each lesson has a `README.md`, a `lab/` folder, a short wiki-style reference, an overview visual, and a flow diagram. The Terraform examples are intentionally small so learners can read the whole lab, run validation quickly, and understand what the plan is doing before anything touches Azure.

## Who It Is For

- Learners preparing for Terraform Associate 004 who prefer Azure examples.
- Microsoft community presenters, trainers, and study group leads.
- Platform engineers who want lightweight workshop labs for Terraform basics.
- Azure practitioners who need better Terraform habits around state, modules, providers, variables, and review workflows.

## What You Will Practice

By the end of the course, learners should be able to:

- Explain Terraform's core workflow: write, format, initialize, validate, plan, apply, and destroy.
- Read Terraform projects by following providers, variables, locals, resources, data sources, modules, and outputs.
- Use variables, validation, collections, functions, loops, lifecycle rules, dynamic blocks, and modules.
- Recognize how Terraform state, locking, imports, moved blocks, removed blocks, and remote backends affect delivery.
- Connect Terraform concepts to Azure patterns such as resource groups, App Service, Storage static websites, Container Apps, Key Vault, Log Analytics, and managed identity.
- Review plans for safety, cost, reliability, and operational clarity before applying.

## Lesson Design

Every lesson follows the same teaching rhythm:

- `Objectives`: what the learner should understand.
- `Scenario`: a small Azure-flavored problem to ground the topic.
- `Walkthrough`: how to read the lab and connect the concept to Terraform behavior.
- `Wiki`: a mini reference with key terms, review cues, and two checked-in SVG visuals.
- `Lab Steps`: commands and workflow for local validation or safe Azure apply.
- `Azure Design Notes`: Well-Architected and Cloud Adoption Framework prompts.
- `Quality Review`: facilitator prompts and extension ideas.
- `Cleanup`: explicit reminders to remove resources and local generated files.
- `Check Questions`: quick review questions for learners or study groups.

Each lesson includes:

- An overview picture: `assets/lesson-XX-visual.svg`
- A flow diagram: `assets/lesson-XX-diagram.svg`
- Terraform lab files under `lab/`
- A consistent public-safe README structure checked by automation

![Lesson 31 diagram](lessons/31-azure-storage-static-assets-lab-new-site-content/assets/lesson-31-diagram.svg)

## Repository Structure

```text
.
|-- README.md
|-- course-map.yml
|-- docs/
|   |-- architecture-review-checklist.md
|   |-- azure-safety-cost-guardrails.md
|   |-- facilitator-guide.md
|   `-- lab-quality-standard.md
|-- exam-review/
|   `-- practice-questions.md
|-- lessons/
|   |-- 01-iac-terraform-mental-model/
|   |   |-- README.md
|   |   |-- assets/
|   |   `-- lab/
|   `-- 40-capstone-review-practice-exam-pack/
|-- shared/
|   |-- modules/
|   |-- quality/
|   `-- scripts/
`-- .github/workflows/terraform-labs.yml
```

## Quick Start

1. Install Terraform 1.12 or newer.
2. Install PowerShell 7 or use Windows PowerShell where available.
3. Clone the repo and open it in VS Code or your editor of choice.
4. Start with [Lesson 01](lessons/01-iac-terraform-mental-model/).
5. For each lesson, open the `lab/` folder and read files in this order: `versions.tf`, `providers.tf` when present, `variables.tf`, `main.tf`, and `outputs.tf`.
6. Run the local workflow from the lesson `lab/` folder:

```powershell
terraform init -backend=false
terraform fmt
terraform validate
terraform plan
```

Only run `terraform apply` in a disposable Azure subscription after reviewing the plan and replacing placeholder values. Destroy resources immediately after the lab unless you are intentionally extending the exercise.

## Validation

Run the fast course hygiene check:

```powershell
./shared/scripts/Test-CourseQuality.ps1 -SkipTerraformInit
```

Run the full validation pass, including Terraform init and validate for every lesson:

```powershell
./shared/scripts/Test-CourseQuality.ps1
```

The quality script checks:

- all 40 lessons exist
- required README sections are present
- every lesson references both SVG assets
- forbidden source markers are absent
- secret, state, plan, key, and generated files are not committed
- `terraform fmt -check -recursive` passes
- each lab initializes and validates when full validation is enabled

## Course Quality Bar

These labs are designed to be defensible in a Microsoft community, workshop, or customer-readiness setting. Each lab includes:

- A concrete learner outcome tied to a Terraform Associate objective.
- Azure Well-Architected discussion prompts across reliability, security, cost optimization, operational excellence, and performance efficiency.
- Cloud Adoption Framework naming and tagging discipline for Azure-facing examples.
- Explicit cleanup, cost-control, and state-safety guidance.
- Repeatable validation through PowerShell quality gates and GitHub Actions.
- Visual aids that make the environment path and Terraform review flow easier to explain.

Start with these course assets:

- [Lab quality standard](docs/lab-quality-standard.md)
- [Architecture review checklist](docs/architecture-review-checklist.md)
- [Azure safety and cost guardrails](docs/azure-safety-cost-guardrails.md)
- [Facilitator guide](docs/facilitator-guide.md)
- [Practice questions](exam-review/practice-questions.md)

## Course Map

| # | Lesson | Area |
|---|--------|------|
| 01 | [IaC and Terraform Mental Model](lessons/01-iac-terraform-mental-model/) | IaC |
| 02 | [Local Tooling: Terraform CLI, Azure CLI, VS Code](lessons/02-local-tooling-terraform-azure-vscode/) | Workflow |
| 03 | [First Azure Resource Group Lab](lessons/03-first-azure-resource-group-lab/) | Workflow |
| 04 | [Terraform Project Anatomy and CLI Workflow](lessons/04-terraform-project-anatomy-cli-workflow/) | Workflow |
| 05 | [Providers, Version Constraints, and Lock Files](lessons/05-providers-version-constraints-lock-files/) | Fundamentals |
| 06 | [Azure Authentication and Provider Configuration](lessons/06-azure-authentication-provider-configuration/) | Fundamentals |
| 07 | [Resources, Data Sources, and References](lessons/07-resources-data-sources-references/) | Configuration |
| 08 | [Dependency Graphs and Explicit Dependencies](lessons/08-dependency-graphs-explicit-dependencies/) | Configuration |
| 09 | [Variables: Defaults, Types, and Descriptions](lessons/09-variables-defaults-types-descriptions/) | Configuration |
| 10 | [Variable Assignment and Precedence](lessons/10-variable-assignment-precedence/) | Configuration |
| 11 | [Validation Rules and Custom Conditions](lessons/11-validation-rules-custom-conditions/) | Configuration |
| 12 | [Sensitive Values and Secret Handling](lessons/12-sensitive-values-secret-handling/) | Configuration |
| 13 | [Locals, Tags, and Naming Standards](lessons/13-locals-tags-naming-standards/) | Configuration |
| 14 | [Outputs and State Visibility](lessons/14-outputs-state-visibility/) | Configuration |
| 15 | [Lists, Maps, Sets, Objects, and Tuples](lessons/15-lists-maps-sets-objects-tuples/) | Configuration |
| 16 | [For Expressions and Collection Transformations](lessons/16-for-expressions-collection-transformations/) | Configuration |
| 17 | [count, Splat Expressions, and Indexing](lessons/17-count-splat-expressions-indexing/) | Configuration |
| 18 | [for_each with Stable Resource Identity](lessons/18-for-each-stable-resource-identity/) | Configuration |
| 19 | [Lifecycle Rules and Replacement Behavior](lessons/19-lifecycle-rules-replacement-behavior/) | Configuration |
| 20 | [Dynamic Blocks and Optional Configuration](lessons/20-dynamic-blocks-optional-configuration/) | Configuration |
| 21 | [Built-in Functions for Azure Naming and CIDR Work](lessons/21-built-in-functions-azure-naming-cidr/) | Configuration |
| 22 | [Azure Remote Backend with Storage Account](lessons/22-azure-remote-backend-storage-account/) | State |
| 23 | [State Locking, Drift, and Refresh-Only Plans](lessons/23-state-locking-drift-refresh-only-plans/) | State |
| 24 | [State Inspection, Import, Moved, and Removed Blocks](lessons/24-state-inspection-import-moved-removed/) | Maintenance |
| 25 | [Workspaces and Environment Separation](lessons/25-workspaces-environment-separation/) | State |
| 26 | [Local Modules and Variable Scope](lessons/26-local-modules-variable-scope/) | Modules |
| 27 | [Module Composition for Networking](lessons/27-module-composition-networking/) | Modules |
| 28 | [Registry Modules and Version Pinning](lessons/28-registry-modules-version-pinning/) | Modules |
| 29 | [Private Module Registry Concepts](lessons/29-private-module-registry-concepts/) | Modules |
| 30 | [Azure App Service Site Lab](lessons/30-azure-app-service-site-lab/) | Azure |
| 31 | [Azure Storage Static Assets Lab with New Site Content](lessons/31-azure-storage-static-assets-lab-new-site-content/) | Azure |
| 32 | [Azure Container Apps Starter Lab](lessons/32-azure-container-apps-starter-lab/) | Azure |
| 33 | [Key Vault and Managed Identity Pattern](lessons/33-key-vault-managed-identity-pattern/) | Azure |
| 34 | [Log Analytics and Monitoring Outputs](lessons/34-log-analytics-monitoring-outputs/) | Azure |
| 35 | [Provisioners, Alternatives, and Safe Use Cases](lessons/35-provisioners-alternatives-safe-use-cases/) | Maintenance |
| 36 | [Debugging, Logs, CLI Config, and Provider Cache](lessons/36-debugging-logs-cli-config-provider-cache/) | Maintenance |
| 37 | [HCP Terraform Workflow Overview](lessons/37-hcp-terraform-workflow-overview/) | HCP Terraform |
| 38 | [HCP Terraform Projects, Workspaces, Variables, and Runs](lessons/38-hcp-terraform-projects-workspaces-variables-runs/) | HCP Terraform |
| 39 | [Governance, Drift Detection, and Policy Concepts](lessons/39-governance-drift-detection-policy-concepts/) | HCP Terraform |
| 40 | [Capstone Review and Practice Exam Pack](lessons/40-capstone-review-practice-exam-pack/) | Review |

## Teaching Flow

For workshops or study groups, use this rhythm:

1. Open the lesson README and discuss the scenario.
2. Use the overview visual to frame the environment path.
3. Use the diagram to explain the Terraform flow.
4. Read the lab files before running commands.
5. Run `terraform fmt`, `terraform init -backend=false`, and `terraform validate`.
6. Review the plan shape before any apply.
7. Discuss the Azure design notes and quality review prompts.
8. Clean up and answer the check questions.

## Safety Notes

- Never commit `terraform.tfvars`, `.terraform/`, `.terraform.lock.hcl`, state files, plan files, credentials, private keys, or generated secrets.
- Labs that use the AzureRM provider include placeholder IDs so `terraform validate` can run consistently. Replace placeholders before applying.
- Concept lessons use local Terraform constructs to keep feedback fast and avoid unnecessary cloud cost.
- Apply labs only in a training subscription with budget alerts and permissions scoped for temporary resources.
- Treat Terraform state as sensitive operational data even when the configuration is public.

## Public Use

This repository is intended to be public learning material. The course content is original, uses fresh examples, and links to official references where appropriate. If you adapt it for a workshop, keep the safety guidance visible and run the course quality gate before publishing changes.
