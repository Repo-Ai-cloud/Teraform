# Certified Terraform Associate: Azure Edition

This repository is an original Azure-focused study course for Terraform Associate 004. It uses fresh scenarios, fresh naming, and new lab files. The course follows the public HashiCorp exam objectives and keeps provider-specific details practical without making Azure trivia the center of the exam preparation.

Official objective reference: https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004

## Course Quality Bar

These labs are designed to be defensible in a Microsoft community, workshop, or customer-readiness setting. Each lab now includes:

- A concrete learner outcome tied to a Terraform Associate objective.
- Azure Well-Architected discussion prompts across reliability, security, cost optimization, operational excellence, and performance efficiency.
- Cloud Adoption Framework naming and tagging discipline for Azure-facing examples.
- Explicit cleanup, cost-control, and state-safety guidance.
- Repeatable validation through PowerShell quality gates and GitHub Actions.

Start with these course assets:

- [Lab quality standard](docs/lab-quality-standard.md)
- [Architecture review checklist](docs/architecture-review-checklist.md)
- [Azure safety and cost guardrails](docs/azure-safety-cost-guardrails.md)
- [Facilitator guide](docs/facilitator-guide.md)
- [Practice questions](exam-review/practice-questions.md)

## How to Use This Course

1. Work through the lessons in order.
2. For each lesson, open the `lab/` folder and run `terraform init`, `terraform fmt`, `terraform validate`, and `terraform plan`.
3. Apply only in a disposable Azure subscription after replacing placeholder subscription or tenant IDs.
4. Destroy any Azure resources immediately after each lab unless you are intentionally extending the exercise.
5. Run `shared/scripts/Test-CourseQuality.ps1` before publishing, teaching, or modifying the labs.

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

## Safety Notes

- Never commit `terraform.tfvars`, `.terraform/`, `.terraform.lock.hcl`, state files, plan files, credentials, or generated secrets unless your team has explicitly approved that workflow.
- Labs that use the AzureRM provider include placeholder IDs so `terraform validate` can run consistently. Replace placeholders before applying.
- Concept lessons use local Terraform constructs to keep feedback fast and avoid unnecessary cloud cost.
- Apply labs only in a training subscription with budget alerts and permissions scoped for temporary resources.


