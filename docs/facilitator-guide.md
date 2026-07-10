# Facilitator Guide

This guide helps an instructor deliver the course as an exam-aligned Microsoft community workshop.

## Before the Workshop

1. Confirm the dated exam status in `course-map.yml` still matches the [official certification page](https://developer.hashicorp.com/certifications/infrastructure-automation).
2. Choose the runtime profile:

   ```powershell
   ./shared/scripts/Test-CourseEnvironment.ps1 -Profile ExamBaseline
   # or
   ./shared/scripts/Test-CourseEnvironment.ps1 -Profile CurrentStable
   ```

3. Run `./shared/scripts/Test-CourseQuality.ps1` twice. A second run must also pass and leave no `.terraform` directories or changed lock files.
4. For live Azure lessons, run the environment check with `-RequireAzureLogin`, verify the subscription, register only the required providers, and create a budget alert.
5. Decide which lessons are local-only, plan-only, live Azure, or optional HCP. Never surprise learners with an account or paid-tier requirement.

## Version Language

- Say **"Terraform 1.12 is the 004 exam baseline"** when discussing certification behavior.
- Say **"Terraform 1.15.8 is the current compatibility lane verified on 2026-07-10"** when demonstrating newer tooling.
- Do not imply that installing the newest Terraform changes the published exam objectives.
- Explain that provider constraints express compatibility while the committed lock file records the reviewed selection.

## Suggested Delivery Paths

- Half-day briefing: Lessons 1, 3, 5, 7, 11, 12, 22, 24, 28, 37, and 40.
- Two-day workshop: Lessons 1-21 on day one; state, modules, Azure implementations, HCP, and review on day two.
- Four-week study group: ten lessons per week, with one 30-question practice set after weeks two and four.

## Demonstration Flow

1. State the exact objective ID and whether the lesson evidence is hands-on, guided, or conceptual.
2. Ask learners to predict inputs, dependencies, plan actions, state effects, and cleanup.
3. Read the root module in order: versions/providers, variables, locals/resources/data/modules, then outputs.
4. Run formatting, read-only initialization, validation, tests, and plan as the lesson directs.
5. Compare exam-neutral Terraform behavior with the Azure implementation choice.
6. Show the expected failure mode and recovery path.
7. Clean up and verify that no cloud resources or sensitive local artifacts remain.

## HCP Terraform Delivery

Lessons 37-39 default to account-free explanation. The optional workflow uses a free HCP account for CLI login, remote runs, managed state, projects, two workspaces, variable sets, and run triggers. Paid-tier governance screens remain guided demonstrations. Keep Terraform Enterprise terminology distinct from HCP Terraform and Community Edition.

## Readiness Evaluation

A learner is ready for the capstone when they can:

- Explain all eight objective groups without relying on Azure-specific trivia.
- Predict provider/module installation and lock-file behavior.
- Read a plan and describe state, dependency, replacement, import, and drift implications.
- Distinguish redaction, state protection, ephemeral values, and write-only arguments.
- Explain local, remote-backend, and HCP Terraform workflows and their locking/authentication boundaries.
- Complete an original practice set and explain why incorrect distractors are wrong.
