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
