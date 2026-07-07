# Practice Questions

1. Why does Terraform need state?
2. What command initializes providers and modules for a working directory?
3. When should `for_each` be preferred over `count`?
4. Which files should usually stay out of source control in a Terraform project?
5. What problem does a remote backend solve for a team?
6. What is the difference between a resource block and a data block?
7. Why should provider and module versions be pinned?
8. What HCP Terraform feature helps teams centralize reusable input values?
9. How can Terraform represent a resource address change without destroying the object?
10. What review step should happen before `terraform apply`?
11. What Terraform Associate 004 topic does `depends_on` support?
12. Why should `depends_on` be used sparingly?
13. What does `create_before_destroy` ask Terraform to do?
14. When can `create_before_destroy` fail even if it is configured correctly?
15. What is the difference between variable validation and a lifecycle precondition?
16. What does a postcondition check after Terraform evaluates a resource?
17. What is the purpose of a `check` block?
18. What does marking a variable `sensitive` do and not do?
19. Why should real secrets come from Vault or another secret manager instead of source control?
20. What is an ephemeral value intended to avoid?
21. What are write-only provider arguments used for?
22. Why is provider-specific cloud knowledge not the main focus of the Terraform Associate exam?
23. What is the difference between a local backend and a remote backend?
24. What command mode can help reconcile Terraform state with real infrastructure drift without changing resources?
25. What does an import block or import workflow help Terraform do?
26. What does HCP Terraform remote operations move away from the operator workstation?
27. What is an HCP Terraform project used to organize?
28. When should HCP Terraform variable sets be preferred over per-workspace variables?
29. What are run triggers used for in HCP Terraform?
30. What HCP Terraform features help teams review drift and enforce governance?

## Answer Key

1. State maps configuration to real infrastructure and stores metadata Terraform needs for planning.
2. `terraform init`.
3. Use `for_each` when each instance has a stable key or identity.
4. State, plan files, local tfvars files with secrets, credentials, and local working directories.
5. It centralizes state, supports collaboration, and can enable locking.
6. A resource manages infrastructure; a data block reads existing information.
7. Pinning improves repeatability and makes upgrades intentional.
8. Variable sets.
9. Use a `moved` block for supported refactors.
10. Review the execution plan for expected creates, updates, replacements, and destroys.
11. It supports defining resource dependencies in configuration.
12. Prefer normal references when possible; explicit dependencies hide intent if they are used for every relationship.
13. It asks Terraform to create the replacement object before destroying the old one.
14. It can fail when the platform does not allow two objects with the same name or overlapping constraints.
15. Variable validation checks input values; a precondition checks assumptions at a resource, data source, or output boundary.
16. It checks that the resulting object or value satisfies an expected condition.
17. A `check` block validates an assertion without directly managing infrastructure.
18. It hides values in CLI output, but the value can still be present in state if it is used in state-backed configuration.
19. Secret managers keep credentials out of code, support rotation, and provide access control and auditability.
20. It helps avoid persisting transient credentials in Terraform plan or state data.
21. They let a provider accept secret values without returning or storing them as normal readable attributes.
22. The exam tests Terraform concepts that apply across providers, even when tutorials use a specific cloud.
23. A local backend stores state on the workstation; a remote backend stores state in shared infrastructure and can support collaboration and locking.
24. `terraform plan -refresh-only`.
25. It brings an existing real object under Terraform state management.
26. Planning, applying, state handling, logs, policy checks, and approvals can move into the HCP Terraform run workflow.
27. Projects organize related workspaces and their governance boundaries.
28. Use variable sets for shared values that many workspaces need, such as cloud IDs, common tags, or environment defaults.
29. They connect workspace runs so an upstream workspace can trigger a downstream workspace when outputs or dependencies change.
30. Health assessments, drift detection, policy checks, run tasks, permissions, and approval gates.
