# Facilitator Guide

This guide helps an instructor run the course as a polished Microsoft community workshop.

## Before the Workshop

- Run `shared/scripts/Test-CourseQuality.ps1` from the course root.
- Confirm the installed Terraform version is `>= 1.12.0`.
- Confirm Azure CLI can authenticate to the target training subscription.
- Create or confirm a budget alert in the training subscription.
- Decide which Azure-resource lessons will be applied live and which will be shown with plan-only output.

## Suggested Delivery Paths

- Half-day briefing: Lessons 1, 3, 5, 9, 13, 18, 22, 26, 30, 37, 40.
- Two-day workshop: Lessons 1 through 22 on day one; lessons 23 through 40 on day two.
- Four-week study group: ten lessons per week, with lesson 40 used as a capstone review.

## Demo Flow

1. State the learner outcome and scenario.
2. Open the lab files in this order: `versions.tf`, `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`.
3. Ask the room to predict the plan.
4. Run `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and `terraform plan`.
5. Discuss one Well-Architected tradeoff.
6. Show the cleanup path before applying anything.

## Evaluation

A learner is ready to move on when they can explain:

- Why Terraform needs state.
- Which part of the configuration owns each value.
- What the plan means.
- How the lab names and tags support operations.
- How they would clean up and verify no resources remain.
