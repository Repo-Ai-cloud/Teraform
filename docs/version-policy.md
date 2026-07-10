# Version and Freshness Policy

## Two Terraform Lanes

- **Exam baseline:** Terraform 1.12.0 represents the product family tested by Terraform Associate 004.
- **Current compatibility:** Terraform 1.15.8 verifies that the course remains useful with the current stable CLI as of 2026-07-10.

All modules require `>= 1.12.0, < 2.0.0`. A newer compatibility lane never changes the certification baseline without a published HashiCorp exam revision.

## Provider and Module Selection

Root modules set supported-major constraints and commit `.terraform.lock.hcl`. Locks record exact provider selections and checksums; they do not lock remote module versions. Registry module blocks therefore set an explicit `version`.

Current reviewed selections:

| Dependency | Constraint policy | Locked/referenced version |
|---|---|---:|
| `hashicorp/azurerm` | `~> 4.80` in roots | 4.80.0 |
| `hashicorp/random` | `~> 3.9` in roots | 3.9.0 |
| `hashicorp/local` | `~> 2.9` in roots | 2.9.0 |
| `hashicorp/subnets/cidr` module | exact module version | 1.0.0 |
| Azure AVM virtual network review example | `~> 0.19` | 0.19.x |

GitHub Actions uses the current reviewed major releases `actions/checkout@v7`, `hashicorp/setup-terraform@v4`, and `actions/cache@v6`. The monthly freshness job reports a newer major instead of silently adopting it.

Reusable child modules declare minimum provider compatibility. The consuming root module supplies the upper bound and lock selection.

## Intentional Updates

Check whether locks are current without editing the repository:

```powershell
./shared/scripts/Update-CourseLocks.ps1 -Check
```

Run the script without `-Check` only on a dependency-update branch. Review provider release notes, regenerated cross-platform hashes, both Terraform CI lanes, and representative plans before committing.

## Freshness Monitoring

`Test-CourseFreshness.ps1` and the monthly/manual freshness workflow compare the recorded certification, CLI, provider, Azure CLI, and action versions with official sources. They report drift and never rewrite content or silently advance the exam baseline.

When updating `verified_on`:

1. Confirm the current exam code and tested Terraform family on HashiCorp's certification page.
2. Compare the exact objective catalog and sample formats.
3. Validate every root with both Terraform lanes and committed locks.
4. Update dated documentation and provider/module examples together.
5. Record any curriculum delta in the objective map and affected lessons.
