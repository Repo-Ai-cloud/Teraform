# Terraform Associate 004 Practice Bank

These 60 original questions use the three formats shown in the [official Terraform Associate 004 samples](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004): true/false, single choice, and multiple answer. They are study material, not leaked exam content, and they make no claim about the live exam question count or passing score.

Each 30-question set contains 5 true/false, 15 single-choice, and 10 multiple-answer questions. Complete a set before opening its answer sections.

<a id="practice-set-a"></a>

## Practice set A — Questions 01–30

### Q01 — Configuration is not state

- **Objective:** `1a`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 01](../lessons/01-iac-terraform-mental-model/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A Terraform configuration is merely an inventory of objects that already exist; it does not express a desired result.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Infrastructure as code records a reviewable desired state. Terraform then compares that configuration with state and provider observations to propose actions.

**Distractor explanations:**

- `A` — This reduces IaC to discovery. Terraform configuration declares intent and can create, update, or remove managed objects.

</details>

### Q02 — Repeatable review

- **Objective:** `1b`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 01](../lessons/01-iac-terraform-mental-model/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Version-controlled Terraform configuration can make infrastructure changes repeatable and reviewable before they are applied.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Declarative configuration, version control, and execution plans support repeatability, peer review, and automation.

**Distractor explanations:**

- `B` — IaC does not eliminate review; it gives reviewers a stable configuration and plan to inspect.

</details>

### Q03 — Provider-neutral workflow

- **Objective:** `1c`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 01](../lessons/01-iac-terraform-mental-model/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Terraform can use one workflow across cloud, on-premises, and SaaS APIs because providers translate resource operations for different services.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Terraform's provider model supports multi-cloud, hybrid, and service-agnostic workflows while each provider handles its own API.

**Distractor explanations:**

- `B` — Terraform is not limited to one cloud or only to infrastructure hosted in public clouds.

</details>

### Q04 — Lock files are intentional

- **Objective:** `2a`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 05](../lessons/05-providers-version-constraints-lock-files/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A root module's dependency lock file should normally be committed so provider selections remain reproducible across workstations and CI.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** The lock file records selected provider versions and checksums. Committing it makes changes to those selections explicit.

**Distractor explanations:**

- `B` — Deleting or ignoring every lock file lets compatible constraints resolve differently and weakens reproducibility.

</details>

### Q05 — State contains operational data

- **Objective:** `2d`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 14](../lessons/14-outputs-state-visibility/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Terraform state contains only resource addresses and never stores resource attribute values.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** State maps resource instances to remote objects and stores attributes and metadata Terraform needs. It must be treated as sensitive operational data.

**Distractor explanations:**

- `A` — State frequently contains resource attributes and can contain sensitive values even when CLI output is redacted.

</details>

### Q06 — Provider responsibility

- **Objective:** `2b`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 06](../lessons/06-azure-authentication-provider-configuration/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

What is the primary role of a Terraform provider?

- [ ] A. Store every backend state snapshot
- [ ] B. Translate Terraform operations into calls to a service API
- [ ] C. Format all configuration files
- [ ] D. Replace the Terraform CLI

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Providers expose resource and data-source types and communicate with the corresponding remote or local API.

**Distractor explanations:**

- `A` — Backends, not providers, determine where state is stored.
- `C` — terraform fmt is a CLI function, not the provider's primary role.
- `D` — Providers are plugins used by Terraform; they do not replace the CLI.

</details>

### Q07 — Two provider configurations

- **Objective:** `2c`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 30](../lessons/30-azure-app-service-site-lab/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A root module needs AzureRM plus Random, and it must use a second Azure subscription for one resource. Which design is valid?

- [ ] A. Declare both provider requirements and use an aliased AzureRM configuration for the second subscription
- [ ] B. Put two source addresses in one provider block
- [ ] C. Rename every resource to include its provider version
- [ ] D. Create a separate state file for every resource automatically

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** A configuration can require multiple providers and can define aliased configurations of the same provider. A resource selects an alias with its provider meta-argument.

**Distractor explanations:**

- `B` — A provider configuration represents one provider source and configuration.
- `C` — Resource names do not select or version providers.
- `D` — Provider multiplicity does not require one state file per resource.

</details>

### Q08 — Core workflow order

- **Objective:** `3a`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 04](../lessons/04-terraform-project-anatomy-cli-workflow/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which sequence best represents the normal Terraform core workflow after configuration is authored?

- [ ] A. apply, init, plan
- [ ] B. init, plan, apply
- [ ] C. destroy, validate, import
- [ ] D. fmt, state rm, login

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Initialize the working directory, review an execution plan, and then apply the reviewed changes. Formatting and validation are useful checks around that flow.

**Distractor explanations:**

- `A` — Terraform must initialize before it can reliably plan or apply.
- `C` — Destroy and import are maintenance actions, not the normal creation workflow.
- `D` — These commands do not form the core plan-and-apply workflow.

</details>

### Q09 — Initialization effect

- **Objective:** `3b`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 05](../lessons/05-providers-version-constraints-lock-files/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

What does terraform init do in a new root module that declares external providers?

- [ ] A. It creates every configured resource
- [ ] B. It prepares the working directory and installs provider selections
- [ ] C. It rewrites variables with production values
- [ ] D. It deletes any existing state

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Initialization installs or reuses providers and modules, configures the backend, and prepares the .terraform working data.

**Distractor explanations:**

- `A` — Resource creation occurs during apply.
- `C` — Initialization does not choose business input values.
- `D` — Initialization may migrate a backend when explicitly requested, but it does not simply delete state.

</details>

### Q10 — Static validation boundary

- **Objective:** `3c`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 11](../lessons/11-validation-rules-custom-conditions/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which statement about terraform validate is correct?

- [ ] A. It proves Azure has capacity for every planned resource
- [ ] B. It checks configuration syntax and internal consistency without proposing remote changes
- [ ] C. It applies only resources with validation blocks
- [ ] D. It replaces provider authentication

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Validation checks whether a configuration is syntactically valid and internally consistent. It does not confirm all provider-side runtime conditions.

**Distractor explanations:**

- `A` — Capacity and remote API rules are provider-side concerns usually found during planning or applying.
- `C` — validate does not apply infrastructure.
- `D` — Provider operations still require appropriate authentication.

</details>

### Q11 — Reviewing a saved plan

- **Objective:** `3d`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 08](../lessons/08-dependency-graphs-explicit-dependencies/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A plan includes the symbol -/+ beside a resource. What should a reviewer conclude?

- [ ] A. Terraform will read the object only
- [ ] B. Terraform proposes replacing the resource
- [ ] C. Terraform will ignore all lifecycle settings
- [ ] D. Terraform has already completed the replacement

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** The -/+ action denotes destroy-and-create replacement. The reviewer should inspect why replacement is required before applying.

**Distractor explanations:**

- `A` — Read-only operations do not use the replacement symbol.
- `C` — Lifecycle settings can influence replacement ordering and protection.
- `D` — A plan proposes actions; it does not report that they have already run.

</details>

### Q12 — Applying reviewed actions

- **Objective:** `3e`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 03](../lessons/03-first-azure-resource-group-lab/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

What happens when terraform apply successfully executes an approved plan?

- [ ] A. Terraform performs the proposed provider operations and records the resulting state
- [ ] B. Terraform only checks formatting
- [ ] C. Terraform installs the Azure CLI
- [ ] D. Terraform converts all resources to data sources

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Apply asks providers to perform the planned operations and updates state to reflect the resulting managed objects.

**Distractor explanations:**

- `B` — Formatting is handled by terraform fmt.
- `C` — Terraform does not install the Azure CLI as part of apply.
- `D` — Managed resources remain resource instances; apply does not convert block types.

</details>

### Q13 — Destroy scope

- **Objective:** `3f`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 03](../lessons/03-first-azure-resource-group-lab/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

From a root module, what does terraform destroy normally target?

- [ ] A. Every object in the cloud subscription
- [ ] B. Objects managed by the current configuration and state
- [ ] C. Only provider binaries
- [ ] D. Only resources created in the last hour

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Destroy creates and applies a plan to remove objects tracked by the current root module's state, subject to configuration and lifecycle rules.

**Distractor explanations:**

- `A` — Terraform does not indiscriminately delete an entire subscription.
- `C` — Provider plugins are working-directory dependencies, not destroy targets.
- `D` — Object age does not define destroy scope.

</details>

### Q14 — Formatting scope

- **Objective:** `3g`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 04](../lessons/04-terraform-project-anatomy-cli-workflow/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which command recursively checks formatting in CI without rewriting files?

- [ ] A. terraform fmt -check -recursive
- [ ] B. terraform validate -write
- [ ] C. terraform plan -format
- [ ] D. terraform init -style

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** terraform fmt supports -check and -recursive, making it suitable for a read-only style gate.

**Distractor explanations:**

- `B` — validate has no -write formatting mode.
- `C` — plan does not format source files.
- `D` — init prepares dependencies and backends, not source style.

</details>

### Q15 — Managed versus queried

- **Objective:** `4a`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 07](../lessons/07-resources-data-sources-references/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A configuration must create a resource group and read details about the currently authenticated Azure client. Which blocks fit those tasks?

- [ ] A. A data block for both
- [ ] B. A resource block for both
- [ ] C. A resource block for the resource group and a data block for client details
- [ ] D. An output block for the resource group and a variable block for client details

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `C`

**Rationale:** A resource block manages lifecycle; a data block reads information. References can connect values from either block to other configuration.

**Distractor explanations:**

- `A` — A data source does not create the resource group.
- `B` — Client context is queried rather than managed as infrastructure.
- `D` — Outputs expose values and variables accept inputs; neither substitutes for the required provider operations.

</details>

### Q16 — Reference creates an edge

- **Objective:** `4b`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 07](../lessons/07-resources-data-sources-references/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

An Azure resource uses azurerm_resource_group.main.location for its location. What does that expression do?

- [ ] A. Copies text only and creates no relationship
- [ ] B. References the managed resource attribute and creates an implicit dependency
- [ ] C. Imports the resource group
- [ ] D. Selects a Terraform workspace

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** A reference reads the resource group's resulting location and lets Terraform infer an ordering edge in the dependency graph.

**Distractor explanations:**

- `A` — References are evaluated expressions and normally imply dependencies.
- `C` — Import is a separate state-management operation.
- `D` — Workspace selection is controlled by workspace commands or environment configuration.

</details>

### Q17 — Input and output boundaries

- **Objective:** `4c`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 14](../lessons/14-outputs-state-visibility/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which design gives a reusable root module an input location and exposes the created resource ID to callers?

- [ ] A. A variable for location and an output for the resource ID
- [ ] B. Two provider aliases
- [ ] C. A backend block and a moved block
- [ ] D. A provisioner and a check block

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Variables define input boundaries and outputs publish selected resulting values.

**Distractor explanations:**

- `B` — Provider aliases select provider configurations, not general module inputs and outputs.
- `C` — Backends store state and moved blocks record address refactors.
- `D` — Neither construct defines the normal module value interface.

</details>

### Q18 — Object type shape

- **Objective:** `4d`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 15](../lessons/15-lists-maps-sets-objects-tuples/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which type constraint best models a service with a name and a set of unique regions?

- [ ] A. object({ name = string, regions = set(string) })
- [ ] B. list(any, any)
- [ ] C. string({ name, regions })
- [ ] D. map = regions

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** An object declares named attributes and a set enforces unique string elements without index identity.

**Distractor explanations:**

- `B` — list takes one element type and does not model named fields.
- `C` — string is a primitive type and cannot declare object attributes.
- `D` — This is not valid type-constraint syntax and does not express the service name field.

</details>

### Q19 — Dynamic nested blocks

- **Objective:** `4e`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 20](../lessons/20-dynamic-blocks-optional-configuration/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

When is a dynamic block appropriate?

- [ ] A. When generating repeatable nested blocks from a collection
- [ ] B. When selecting the Terraform binary version
- [ ] C. When encrypting state by itself
- [ ] D. When replacing every for expression

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** A dynamic block iterates over a collection to generate nested blocks whose structure cannot be assigned as a normal value.

**Distractor explanations:**

- `B` — required_version constrains Terraform versions.
- `C` — Backend and platform controls protect state; dynamic blocks do not encrypt it.
- `D` — For expressions produce values and remain useful inside or outside dynamic blocks.

</details>

### Q20 — Prefer implicit dependency

- **Objective:** `4f`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 08](../lessons/08-dependency-graphs-explicit-dependencies/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Resource B needs the ID produced by resource A. What is the clearest way to express the dependency?

- [ ] A. Reference resource A's ID in resource B
- [ ] B. Add an unrelated sleep provisioner
- [ ] C. Depend on the entire module with no value reference
- [ ] D. Run apply twice

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** A direct attribute reference documents the data flow and allows Terraform to infer the dependency. Explicit depends_on is reserved for hidden behavioral dependencies.

**Distractor explanations:**

- `B` — A delay does not describe the real dependency.
- `C` — A broad dependency can make plans unnecessarily conservative when a direct reference exists.
- `D` — Repeating apply is not a dependency declaration.

</details>

### Q21 — Condition boundaries

- **Objective:** `4g`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 11](../lessons/11-validation-rules-custom-conditions/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three statements correctly match Terraform custom-condition mechanisms? Select 3 answers.

- [ ] A. Variable validation can reject an invalid input value
- [ ] B. A lifecycle precondition can stop an operation when an assumption is false
- [ ] C. A check block can report an assertion without directly managing a resource
- [ ] D. A postcondition installs a missing provider
- [ ] E. terraform fmt evaluates remote service health

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Validation, preconditions, postconditions, and check blocks place assertions at different boundaries. The first three options describe valid uses.

**Distractor explanations:**

- `D` — Postconditions verify a result after evaluation; provider installation belongs to init.
- `E` — fmt adjusts configuration style and does not query service health.

</details>

### Q22 — Sensitive-data controls

- **Objective:** `4h`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 12](../lessons/12-sensitive-values-secret-handling/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three practices reduce exposure of sensitive data in a Terraform workflow? Select 3 answers.

- [ ] A. Retrieve secrets from a dedicated secrets manager such as HashiCorp Vault
- [ ] B. Restrict and encrypt access to state
- [ ] C. Mark sensitive inputs and outputs so routine CLI output is redacted
- [ ] D. Commit production tfvars files for convenient sharing
- [ ] E. Assume sensitive = true removes the value from state

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Secret management, state protection, and output redaction address different exposure paths. Sensitive marking alone is not a state-elision feature.

**Distractor explanations:**

- `D` — Secret-bearing tfvars files should not be committed.
- `E` — Sensitive marking hides routine display but a state-backed value can still be stored in state.

</details>

### Q23 — Module source forms

- **Objective:** `5a`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 28](../lessons/28-registry-modules-version-pinning/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three are valid categories of Terraform module source? Select 3 answers.

- [ ] A. A relative local path
- [ ] B. A public or private registry address
- [ ] C. A supported version-control source such as Git
- [ ] D. A resource address from state
- [ ] E. An output name without a path

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Terraform can install child modules from local paths, registries, and supported remote package or version-control locations.

**Distractor explanations:**

- `D` — Resource addresses identify instances in configuration or state, not module packages.
- `E` — An output name is not a module source address.

</details>

### Q24 — Module value scope

- **Objective:** `5b`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 26](../lessons/26-local-modules-variable-scope/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two statements about module variable scope are correct? Select 2 answers.

- [ ] A. A child module receives values through its declared input variables
- [ ] B. A parent reads selected child values through child outputs
- [ ] C. Every child can directly read all parent locals
- [ ] D. Child variable defaults automatically overwrite parent variables

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** Inputs and outputs form the explicit value interface between parent and child modules.

**Distractor explanations:**

- `C` — Parent locals are not automatically in child scope.
- `D` — Child defaults apply only when the caller omits an input and do not mutate parent variables.

</details>

### Q25 — Using a child module

- **Objective:** `5c`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 27](../lessons/27-module-composition-networking/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two actions are part of using a child module effectively? Select 2 answers.

- [ ] A. Pass required input arguments in a module block
- [ ] B. Reference module outputs where downstream configuration needs them
- [ ] C. Copy the child's state into every resource block
- [ ] D. Declare the child as a provider alias

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** A module block supplies inputs, and module.NAME.OUTPUT references expose the child's public results for composition.

**Distractor explanations:**

- `C` — Modules in one configuration share the root state; state is not copied into blocks.
- `D` — A module is not a provider configuration.

</details>

### Q26 — Versioned registry modules

- **Objective:** `5d`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 28](../lessons/28-registry-modules-version-pinning/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two practices make registry-module upgrades intentional? Select 2 answers.

- [ ] A. Add a version constraint to the module block
- [ ] B. Review the changelog and execution plan before changing the selected version
- [ ] C. Delete the module source on every plan
- [ ] D. Use a floating branch name as a registry version

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** A version constraint bounds selection; upgrade review confirms behavior before adoption.

**Distractor explanations:**

- `C` — Deleting source code is unrelated to safe version management.
- `D` — Registry module versions use published version numbers and constraints, not branch names.

</details>

### Q27 — Local backend behavior

- **Objective:** `6a`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 23](../lessons/23-state-locking-drift-refresh-only-plans/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two statements describe the local backend? Select 2 answers.

- [ ] A. It stores state on the local filesystem by default
- [ ] B. It is simple for individual experiments but needs care for team collaboration
- [ ] C. It automatically provides organization-wide remote locking
- [ ] D. It uploads state to HCP Terraform without configuration

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** The local backend keeps state locally and is convenient for small isolated work. Shared teams generally need a deliberately configured remote solution.

**Distractor explanations:**

- `C` — Local filesystem state does not provide organization-wide remote locking.
- `D` — HCP Terraform integration must be configured; it is not implicit local-backend behavior.

</details>

### Q28 — Lock handling

- **Objective:** `6b`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 23](../lessons/23-state-locking-drift-refresh-only-plans/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A state lock is already held. Which two responses are appropriate? Select 2 answers.

- [ ] A. Wait for the active operation or coordinate with its owner
- [ ] B. Investigate whether the lock is stale before considering force-unlock
- [ ] C. Delete state immediately
- [ ] D. Run concurrent applies until one succeeds

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** Locking prevents concurrent writers. Force-unlock is a recovery action only after verifying no legitimate operation still owns the lock.

**Distractor explanations:**

- `C` — Deleting state risks losing the mapping to managed objects.
- `D` — Competing writes are exactly what state locking is designed to prevent.

</details>

### Q29 — Remote backend configuration

- **Objective:** `6c`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 22](../lessons/22-azure-remote-backend-storage-account/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two statements are correct for an Azure Storage remote backend? Select 2 answers.

- [ ] A. Declare the azurerm backend in the terraform block and initialize it
- [ ] B. Keep authentication secrets out of committed backend configuration
- [ ] C. Put the backend block inside a managed resource
- [ ] D. Expect backend settings to come from normal input variables

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** Backends are initialized before normal expression evaluation. Commit non-secret structure, supply environment-specific settings securely, and reinitialize when backend configuration changes.

**Distractor explanations:**

- `C` — A backend block belongs inside the top-level terraform block.
- `D` — Backend blocks cannot use ordinary input variables because backend initialization happens earlier.

</details>

### Q30 — Drift and refactoring

- **Objective:** `6d`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 24](../lessons/24-state-inspection-import-moved-removed/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three tools or workflows can manage drift or state relationships without blindly recreating everything? Select 3 answers.

- [ ] A. Review a refresh-only plan
- [ ] B. Record an address rename with a moved block
- [ ] C. Remove management intentionally with a removed block
- [ ] D. Delete the state file whenever an attribute differs
- [ ] E. Edit provider binaries

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Refresh-only mode reconciles observed attributes, while moved and removed blocks make state transitions explicit and reviewable.

**Distractor explanations:**

- `D` — Deleting state discards mappings and does not safely resolve drift.
- `E` — Provider binaries are dependencies, not a state-management interface.

</details>

<a id="practice-set-b"></a>

## Practice set B — Questions 31–60

### Q31 — Import is a state transition

- **Objective:** `7a`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 24](../lessons/24-state-inspection-import-moved-removed/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

After importing an existing object, you must still ensure the configuration describes that object accurately before applying.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Import associates a remote object with a Terraform resource address. Configuration remains the desired-state source and must be reviewed against the resulting plan.

**Distractor explanations:**

- `B` — Import does not make an arbitrary configuration correct or remove the need to review subsequent changes.

</details>

### Q32 — Read-only state inspection

- **Objective:** `7b`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 24](../lessons/24-state-inspection-import-moved-removed/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

terraform state list and terraform state show can inspect tracked instances without editing their remote infrastructure.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** These state subcommands list addresses and show stored attributes. They are useful read-only inspection tools.

**Distractor explanations:**

- `B` — The commands inspect state; they do not perform provider updates to the remote object.

</details>

### Q33 — Logs need protection

- **Objective:** `7c`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 36](../lessons/36-debugging-logs-cli-config-provider-cache/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A file written through TF_LOG_PATH can contain sensitive values and should be protected and deleted after troubleshooting.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Verbose logs may include configuration, provider request, or response details. Limit access, redact before sharing, and clean them up.

**Distractor explanations:**

- `B` — Diagnostic logs are not automatically safe simply because Terraform wrote them.

</details>

### Q34 — Optional no-cost HCP practice

- **Objective:** `8a`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 37](../lessons/37-hcp-terraform-workflow-overview/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A learner can practice a basic HCP Terraform remote run and managed state workflow with an optional free account; paid governance features are not required for that core exercise.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** The course keeps account-based practice optional and separates core remote-run capability from guided discussion of paid-tier governance.

**Distractor explanations:**

- `B` — Basic no-cost practice is possible; the lesson must not imply that every governance feature is included.

</details>

### Q35 — Feature tiers matter

- **Objective:** `8b`
- **Format:** `true_false`
- **Select:** `1`
- **Lesson:** [Lesson 39](../lessons/39-governance-drift-detection-policy-concepts/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Every HCP Terraform governance feature is available in every plan tier, so course labs never need to label paid features separately.

- [ ] A. True
- [ ] B. False

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `B`

**Rationale:** Availability varies. A responsible course distinguishes hands-on free workflows from guided or conceptual paid-tier features.

**Distractor explanations:**

- `A` — Policy enforcement, advanced governance, and other features can depend on the selected HCP Terraform plan.

</details>

### Q36 — Projects and workspaces

- **Objective:** `8c`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 38](../lessons/38-hcp-terraform-projects-workspaces-variables-runs/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

What relationship best describes HCP Terraform projects and workspaces?

- [ ] A. Projects organize related workspaces and provide an administrative boundary
- [ ] B. Each project is a provider binary
- [ ] C. A workspace can never contain variables
- [ ] D. Projects replace Terraform configuration files

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Projects group related workspaces and help apply organization and access boundaries. Workspaces hold configuration/run context and managed state.

**Distractor explanations:**

- `B` — Projects are organizational objects, not plugins.
- `C` — Workspaces can have variables and attached variable sets.
- `D` — HCP objects organize execution; Terraform configuration still defines infrastructure.

</details>

### Q37 — Connect the CLI to HCP

- **Objective:** `8d`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 37](../lessons/37-hcp-terraform-workflow-overview/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which action establishes CLI credentials for HCP Terraform before a remote workflow?

- [ ] A. terraform login
- [ ] B. terraform fmt
- [ ] C. terraform state rm
- [ ] D. terraform providers lock

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** terraform login obtains and stores an API token for a supported HCP Terraform hostname. Configuration must then select the intended organization and workspace.

**Distractor explanations:**

- `B` — fmt only formats configuration.
- `C` — state rm forgets a managed address and is unrelated to authentication.
- `D` — providers lock records provider checksums, not HCP credentials.

</details>

### Q38 — Ephemeral boundary

- **Objective:** `4h`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 12](../lessons/12-sensitive-values-secret-handling/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)
- **Additional 004 topic:** `004-ephemeral-values` — [Sensitive data and ephemeral values](https://developer.hashicorp.com/terraform/language/manage-sensitive-data)

What is the intended benefit of an ephemeral value in supported Terraform contexts?

- [ ] A. Omit a short-lived value from plan and state persistence
- [ ] B. Make every resource permanent
- [ ] C. Display a secret in all logs
- [ ] D. Replace backend encryption

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Ephemeral values are intended for transient data that should not be persisted in plan or state. They complement, rather than replace, broader secret-management controls.

**Distractor explanations:**

- `B` — Ephemeral describes value persistence, not resource lifetime.
- `C` — Avoiding persistence does not authorize log exposure.
- `D` — State and backend protections remain necessary for other data.

</details>

### Q39 — Write-only input

- **Objective:** `4h`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 12](../lessons/12-sensitive-values-secret-handling/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)
- **Additional 004 topic:** `004-write-only-arguments` — [Sensitive data and ephemeral values](https://developer.hashicorp.com/terraform/language/manage-sensitive-data)

What distinguishes a provider's write-only argument from a normal readable resource attribute?

- [ ] A. Terraform can pass the value to the provider without retaining a normal readable result for it
- [ ] B. It is always printed after apply
- [ ] C. It automatically rotates every secret manager
- [ ] D. It can be used by any provider even when its schema does not define it

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** A write-only argument is explicitly implemented by a provider schema to accept sensitive input without returning it as an ordinary stored attribute.

**Distractor explanations:**

- `B` — The purpose is to avoid normal readable persistence, not force display.
- `C` — Rotation behavior depends on the provider and service configuration.
- `D` — The provider must explicitly support a write-only argument.

</details>

### Q40 — Intentional provider upgrade

- **Objective:** `2a`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 05](../lessons/05-providers-version-constraints-lock-files/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A constraint permits a newer provider, but init keeps the version selected in the lock file. Which command requests a deliberate reselection within the constraint?

- [ ] A. terraform init -upgrade
- [ ] B. terraform fmt -upgrade
- [ ] C. terraform state list -upgrade
- [ ] D. terraform output -unlock

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** The -upgrade option tells init to reconsider locked provider and module selections within configured constraints. The resulting lock change should be reviewed and tested.

**Distractor explanations:**

- `B` — fmt has no provider-upgrade role.
- `C` — state list reads tracked addresses.
- `D` — output reads output values and does not update dependencies.

</details>

### Q41 — Redacted but persisted

- **Objective:** `4h`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 12](../lessons/12-sensitive-values-secret-handling/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A sensitive output displays as (sensitive value), but its source is a normal resource attribute. What should the operator assume?

- [ ] A. The value may still exist in plan or state and state access must be protected
- [ ] B. Terraform has deleted the value everywhere
- [ ] C. The backend no longer needs access controls
- [ ] D. The value is automatically stored in HashiCorp Vault

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Sensitive marking controls routine presentation. Unless an ephemeral or write-only boundary applies, Terraform may need to retain the value in plan or state.

**Distractor explanations:**

- `B` — Redaction is not deletion.
- `C` — State remains sensitive and needs encryption and least-privilege access.
- `D` — Terraform does not automatically move marked values into Vault.

</details>

### Q42 — Stable instance identity

- **Objective:** `4e`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 18](../lessons/18-for-each-stable-resource-identity/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A map of regions uses durable region names as keys. Which repetition construct best avoids index shifts when one region is removed?

- [ ] A. for_each over the map
- [ ] B. count over map length
- [ ] C. A provisioner loop
- [ ] D. A backend block per region

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** for_each addresses instances by stable keys, so changing one key does not reindex unrelated instances.

**Distractor explanations:**

- `B` — count addresses instances numerically and list-like changes can shift identities.
- `C` — Provisioners are not a resource-instance repetition construct.
- `D` — Backends store state and are not used to repeat resources.

</details>

### Q43 — Address-only refactor

- **Objective:** `6d`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 24](../lessons/24-state-inspection-import-moved-removed/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A resource block is renamed from random_id.legacy to random_id.service, but the same remote object should remain managed. What records the relationship declaratively?

- [ ] A. A moved block from the old address to the new address
- [ ] B. A new backend
- [ ] C. A sensitive output
- [ ] D. A provider upgrade

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** A moved block tells Terraform that an existing state address corresponds to a new configuration address, allowing the plan to avoid unnecessary replacement.

**Distractor explanations:**

- `B` — Backend migration changes state storage, not a resource address.
- `C` — Sensitivity affects display, not address mapping.
- `D` — Provider upgrades do not document configuration refactors.

</details>

### Q44 — Import target

- **Objective:** `7a`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 24](../lessons/24-state-inspection-import-moved-removed/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Before importing a real object, what must the operator identify?

- [ ] A. The destination Terraform resource address and the provider-specific import ID
- [ ] B. Only the output name
- [ ] C. A new Terraform version outside the constraint
- [ ] D. The lock ID of an unrelated run

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Import needs a Terraform address to receive the state association and an identifier the provider can use to find the remote object.

**Distractor explanations:**

- `B` — Outputs do not define managed resource addresses.
- `C` — Import does not require violating the configured Terraform version range.
- `D` — State-lock IDs are used only for lock recovery, not object import.

</details>

### Q45 — Refresh-only review

- **Objective:** `6d`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 23](../lessons/23-state-locking-drift-refresh-only-plans/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A local_file was edited outside Terraform. Which command proposes updating state and outputs to match observation without changing the file back?

- [ ] A. terraform plan -refresh-only
- [ ] B. terraform fmt
- [ ] C. terraform providers lock
- [ ] D. terraform workspace delete default

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Refresh-only mode reviews how state and outputs would change to reflect remote or local observations without proposing corrective infrastructure changes.

**Distractor explanations:**

- `B` — fmt changes source formatting only.
- `C` — providers lock records dependency checksums.
- `D` — The default workspace cannot be deleted and workspace deletion would not reconcile drift.

</details>

### Q46 — Registry module selection

- **Objective:** `5d`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 28](../lessons/28-registry-modules-version-pinning/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A registry module block declares version = 1.0.0. What does that argument control?

- [ ] A. The selected release of the child module
- [ ] B. The Azure subscription
- [ ] C. The Terraform state serial
- [ ] D. The provider authentication method

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** The module version argument constrains or pins the registry module package selected during initialization.

**Distractor explanations:**

- `B` — Subscription selection belongs to provider configuration and credentials.
- `C` — State serials are backend metadata.
- `D` — Module version selection does not configure provider authentication.

</details>

### Q47 — Selecting an alias

- **Objective:** `2c`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 30](../lessons/30-azure-app-service-site-lab/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A resource must use provider azurerm.secondary instead of the default AzureRM configuration. Which resource meta-argument selects it?

- [ ] A. provider = azurerm.secondary
- [ ] B. backend = azurerm.secondary
- [ ] C. source = resource.secondary
- [ ] D. workspace = provider.secondary

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** The provider meta-argument selects an alternate provider configuration for a resource. Child modules receive aliases through the providers map when required.

**Distractor explanations:**

- `B` — backend is not a resource meta-argument.
- `C` — source addresses belong to provider and module requirements, not resource provider selection.
- `D` — Workspaces do not select provider aliases.

</details>

### Q48 — Managed remote state

- **Objective:** `8a`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 37](../lessons/37-hcp-terraform-workflow-overview/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

What happens to state when an HCP Terraform workspace performs a remote run?

- [ ] A. HCP Terraform manages the workspace state and state versions
- [ ] B. State is intentionally emailed to every team member
- [ ] C. Terraform stops using state
- [ ] D. The state becomes a provider plugin

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** HCP Terraform workspaces manage state versions alongside remote run history and access controls.

**Distractor explanations:**

- `B` — State is stored in the service and controlled through access policy, not distributed by email.
- `C` — Terraform still relies on state.
- `D` — State data and provider plugins serve different purposes.

</details>

### Q49 — Run trigger direction

- **Objective:** `8c`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 38](../lessons/38-hcp-terraform-projects-workspaces-variables-runs/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

A network workspace must cause an application workspace to queue a run after a successful network apply. Which HCP Terraform feature models this?

- [ ] A. A run trigger from the network workspace to the application workspace
- [ ] B. A local backend in both workspaces
- [ ] C. A resource taint on every network object
- [ ] D. A provider lock timeout

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Run triggers connect workspace workflows so a successful upstream apply can queue a downstream run.

**Distractor explanations:**

- `B` — Local backends do not coordinate HCP workspace runs.
- `C` — Replacement marking is unrelated to cross-workspace orchestration.
- `D` — Lock timeout controls waiting for a state lock, not run dependencies.

</details>

### Q50 — Shared variables

- **Objective:** `8b`
- **Format:** `single_choice`
- **Select:** `1`
- **Lesson:** [Lesson 38](../lessons/38-hcp-terraform-projects-workspaces-variables-runs/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Several HCP Terraform workspaces need the same non-secret environment label and Azure region. What reduces duplicated per-workspace entries?

- [ ] A. Attach a variable set to the relevant project or workspaces
- [ ] B. Copy a state snapshot into each configuration
- [ ] C. Add a provisioner to every resource
- [ ] D. Use force-unlock

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`

**Rationale:** Variable sets centralize shared Terraform or environment variables and can be attached at the appropriate organizational scope.

**Distractor explanations:**

- `B` — State is not an input-variable distribution mechanism.
- `C` — Provisioners do not centralize workspace configuration.
- `D` — force-unlock is only for a verified stale state lock.

</details>

### Q51 — Workflow safeguards

- **Objective:** `3a`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 04](../lessons/04-terraform-project-anatomy-cli-workflow/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three actions belong in a careful Terraform change workflow? Select 3 answers.

- [ ] A. Initialize the exact root module being changed
- [ ] B. Review the plan for creates, updates, replacements, and destroys
- [ ] C. Apply only the reviewed change in the intended workspace
- [ ] D. Delete the dependency lock file before every run
- [ ] E. Skip cleanup verification for temporary labs

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Initialization, plan review, and intentional apply form a traceable workflow. Dependency selections and cleanup also deserve deliberate handling.

**Distractor explanations:**

- `D` — Root lock files should normally be retained and changed only during intentional upgrades.
- `E` — Temporary resources and artifacts should be verified as removed.

</details>

### Q52 — Choosing a custom condition

- **Objective:** `4g`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 11](../lessons/11-validation-rules-custom-conditions/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three pairings are appropriate? Select 3 answers.

- [ ] A. Variable validation — reject an unsupported environment string
- [ ] B. Precondition — require an input-dependent assumption before a resource operation
- [ ] C. Postcondition — verify a resulting resource attribute
- [ ] D. depends_on — validate a string with a regular expression
- [ ] E. terraform fmt — test a live endpoint

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** The three condition types match input, pre-operation, and result boundaries respectively.

**Distractor explanations:**

- `D` — depends_on declares dependency ordering and does not validate string content.
- `E` — fmt formats configuration and does not probe endpoints.

</details>

### Q53 — State inspection toolkit

- **Objective:** `7b`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 24](../lessons/24-state-inspection-import-moved-removed/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three commands are read-oriented ways to inspect state-derived information? Select 3 answers.

- [ ] A. terraform state list
- [ ] B. terraform state show ADDRESS
- [ ] C. terraform output
- [ ] D. terraform state rm ADDRESS
- [ ] E. terraform force-unlock LOCK_ID

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** state list, state show, and output expose tracked addresses, attributes, and declared outputs without intentionally changing state membership.

**Distractor explanations:**

- `D` — state rm deliberately removes an address from state.
- `E` — force-unlock changes lock state and is a recovery operation.

</details>

### Q54 — Secret boundaries

- **Objective:** `4h`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 12](../lessons/12-sensitive-values-secret-handling/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three statements are correct about secrets in Terraform? Select 3 answers.

- [ ] A. HashiCorp Vault and Azure Key Vault are distinct products even though both can manage secrets
- [ ] B. A normal sensitive value may still persist in state
- [ ] C. Ephemeral values and provider-supported write-only arguments can reduce persistence in supported contexts
- [ ] D. Marking a value sensitive guarantees it never reaches logs or state
- [ ] E. Committing a secret to source control is safe if the repository is private

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Product terminology matters, redaction is not state elision, and newer ephemeral/write-only boundaries apply only where Terraform and the provider support them.

**Distractor explanations:**

- `D` — Sensitive marking redacts routine output but is not an absolute non-persistence or no-log guarantee.
- `E` — Private repositories still have readers, history, backups, and compromise risk; secrets should not be committed.

</details>

### Q55 — Backend collaboration

- **Objective:** `6b`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 22](../lessons/22-azure-remote-backend-storage-account/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two properties are important when choosing a shared state backend? Select 2 answers.

- [ ] A. Controlled durable state storage
- [ ] B. A locking mechanism or equivalent concurrency protection
- [ ] C. Automatic creation of all application resources
- [ ] D. Permission for every user to bypass authentication

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** A team backend must protect durable state and prevent or coordinate concurrent writes. Azure Blob-backed state supports locking and should use least-privilege Entra authorization.

**Distractor explanations:**

- `C` — The backend stores state; providers create application resources.
- `D` — Shared state requires strong authentication and least privilege, not anonymous bypass.

</details>

### Q56 — HCP connection pieces

- **Objective:** `8d`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 37](../lessons/37-hcp-terraform-workflow-overview/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three steps can be part of connecting a local configuration to an HCP Terraform remote workflow? Select 3 answers.

- [ ] A. Authenticate with terraform login
- [ ] B. Configure the intended HCP organization and workspace
- [ ] C. Run terraform init to initialize the remote integration
- [ ] D. Commit the HCP API token in a tfvars file
- [ ] E. Delete the workspace state before the first plan

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Authentication, explicit workspace selection, and initialization establish the integration. Credentials and existing state require secure handling.

**Distractor explanations:**

- `D` — API tokens are credentials and must not be committed.
- `E` — State migration must be deliberate; deleting state is not a connection step.

</details>

### Q57 — Lifecycle and graph

- **Objective:** `4f`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 19](../lessons/19-lifecycle-rules-replacement-behavior/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two statements about dependency and lifecycle behavior are correct? Select 2 answers.

- [ ] A. Attribute references usually let Terraform infer dependencies
- [ ] B. create_before_destroy can still fail when a platform forbids two objects with the same unique name
- [ ] C. depends_on should replace all value references
- [ ] D. ignore_changes prevents every possible resource replacement

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** References communicate data flow, while lifecycle behavior remains subject to provider and platform constraints.

**Distractor explanations:**

- `C` — Explicit dependencies are for hidden relationships and should not obscure normal references.
- `D` — ignore_changes applies only to selected arguments and does not suppress all replacement causes.

</details>

### Q58 — Read and manage

- **Objective:** `4a`
- **Format:** `multiple_answer`
- **Select:** `2`
- **Lesson:** [Lesson 07](../lessons/07-resources-data-sources-references/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which two statements correctly distinguish data sources and resources? Select 2 answers.

- [ ] A. A resource block asks Terraform to manage an object's lifecycle
- [ ] B. A data block reads information for use elsewhere in configuration
- [ ] C. A data block is always stored in a separate backend
- [ ] D. A resource block can never be referenced

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`

**Rationale:** Resources manage lifecycle and data sources query information; both expose attributes that expressions can reference.

**Distractor explanations:**

- `C` — Data-source results participate in the same configuration and state model; they do not require a separate backend.
- `D` — Resource attributes are routinely referenced to compose infrastructure.

</details>

### Q59 — Module provenance

- **Objective:** `5a`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 28](../lessons/28-registry-modules-version-pinning/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three review items matter before adopting a registry module? Select 3 answers.

- [ ] A. Verify the source namespace and module documentation
- [ ] B. Pin or constrain an intended release
- [ ] C. Review inputs, outputs, provider requirements, and planned resources
- [ ] D. Assume a popular module is automatically safe for every organization
- [ ] E. Copy its state from another user

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Source provenance, version policy, interface review, and plan inspection are core module-adoption checks.

**Distractor explanations:**

- `D` — Popularity does not replace security, architecture, and compatibility review.
- `E` — Consumers initialize module source and create their own state relationships; they do not borrow another user's state.

</details>

### Q60 — Focused diagnostics

- **Objective:** `7c`
- **Format:** `multiple_answer`
- **Select:** `3`
- **Lesson:** [Lesson 36](../lessons/36-debugging-logs-cli-config-provider-cache/)
- **Official reference:** [Terraform Associate 004 exam content list](https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004)

Which three practices make verbose Terraform troubleshooting safer and more useful? Select 3 answers.

- [ ] A. Set an appropriate TF_LOG level only for the diagnostic run
- [ ] B. Direct output with TF_LOG_PATH when a file is needed
- [ ] C. Redact before sharing and delete the log after use
- [ ] D. Commit the raw trace log permanently
- [ ] E. Leave TRACE enabled in every CI run

<details>
<summary>Answer and rationale</summary>

**Correct answer:** `A`, `B`, `C`

**Rationale:** Focused logging captures the needed evidence while limiting duration and exposure. A plugin cache can improve install speed but is separate from log safety.

**Distractor explanations:**

- `D` — Raw logs can contain sensitive or environment-specific details and should not be committed.
- `E` — Continuous TRACE logging creates noise, cost, and exposure; enable it only when needed.

</details>
