[CmdletBinding()]
param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [string]$PluginCacheDir = (Join-Path $env:TEMP "tf-plugin-cache-atfa40"),
  [switch]$SkipTerraformInit,
  [switch]$SkipLockCheck
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "CourseMetadata.ps1")

function Assert-Equal {
  param([string]$Name, [int]$Actual, [int]$Expected)
  if ($Actual -ne $Expected) {
    throw "$Name expected $Expected but found $Actual"
  }
}

function Assert-PathContains {
  param([string]$Path, [string]$Pattern, [string]$Description)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "Missing file for $($Description): $Path"
  }
  if ((Get-Content -LiteralPath $Path -Raw) -notmatch $Pattern) {
    throw "Missing $Description in $Path"
  }
}

function Assert-TreeContains {
  param([string]$Path, [string]$Pattern, [string]$Description)
  $files = @(Get-ChildItem -LiteralPath $Path -Recurse -File -Force |
    Where-Object { $_.FullName -notmatch '[\\/](?:\.terraform|\.git)[\\/]' })
  if (-not ($files | Select-String -Pattern $Pattern)) {
    throw "Missing $Description under $Path"
  }
}

function Assert-NoMatches {
  param([string]$Pattern, [string]$Description)
  $files = Get-ChildItem -LiteralPath $CourseRoot -Recurse -File -Force |
    Where-Object {
      $_.Name -ne "Test-CourseQuality.ps1" -and
      $_.Name -ne ".terraform.lock.hcl" -and
      $_.FullName -notmatch '[\\/](?:\.git|\.terraform)[\\/]'
    }
  $matches = $files | Select-String -Pattern $Pattern -SimpleMatch
  if ($matches) {
    $matches | ForEach-Object { Write-Host "$($_.Path):$($_.LineNumber):$($_.Line)" }
    throw "Found forbidden marker: $Description"
  }
}

$expectedObjectives = [ordered]@{
  "1a" = "Explain what IaC is"
  "1b" = "Describe the advantages of IaC patterns"
  "1c" = "Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows"
  "2a" = "Install and version Terraform providers"
  "2b" = "Describe how Terraform uses providers"
  "2c" = "Write Terraform configuration using multiple providers"
  "2d" = "Explain how Terraform uses and manages state"
  "3a" = "Describe the Terraform workflow"
  "3b" = "Initialize a Terraform working directory"
  "3c" = "Validate a Terraform configuration"
  "3d" = "Generate and review an execution plan for Terraform"
  "3e" = "Apply changes to infrastructure with Terraform"
  "3f" = "Destroy Terraform-managed infrastructure"
  "3g" = "Apply formatting and style adjustments to a configuration"
  "4a" = 'Use and differentiate `resource` and `data` blocks'
  "4b" = "Refer to resource attributes and create cross-resource references"
  "4c" = "Use variables and outputs"
  "4d" = "Understand and use complex types"
  "4e" = "Write dynamic configuration using expressions and functions"
  "4f" = "Define resource dependencies in configuration"
  "4g" = "Validate configuration using custom conditions"
  "4h" = "Understand best practices for managing sensitive data, including secrets management with Vault"
  "5a" = "Explain how Terraform sources modules"
  "5b" = "Describe variable scope within modules"
  "5c" = "Use modules in configuration"
  "5d" = "Manage module versions"
  "6a" = "Describe the local backend"
  "6b" = "Describe state locking"
  "6c" = "Configure remote state using the backend block"
  "6d" = "Manage resource drift and Terraform state"
  "7a" = "Import existing infrastructure into your Terraform workspace"
  "7b" = "Use the CLI to inspect state"
  "7c" = "Describe when and how to use verbose logging"
  "8a" = "Use HCP Terraform to create infrastructure"
  "8b" = "Describe HCP Terraform collaboration and governance features"
  "8c" = "Describe how to organize and use HCP Terraform workspaces and projects"
  "8d" = "Configure and use HCP Terraform integration"
}

$metadata = Get-CourseMetadata -CourseRoot $CourseRoot
$requiredMetadata = [ordered]@{
  "certification.exam_code" = "Terraform Associate 004"
  "certification.status" = "current"
  "certification.verified_on" = "2026-07-10"
  "certification.product_version_tested" = "1.12"
  "certification.certification_url" = "https://developer.hashicorp.com/certifications/infrastructure-automation"
  "certification.prep_collection_url" = "https://developer.hashicorp.com/terraform/tutorials/certification-004"
  "certification.learning_path_url" = "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-study-004"
  "certification.objectives_url" = "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004"
  "certification.sample_questions_url" = "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004"
  "toolchain.verified_on" = "2026-07-10"
  "toolchain.terraform.required_version" = ">= 1.12.0, < 2.0.0"
  "toolchain.terraform.exam_baseline" = "1.12.0"
  "toolchain.terraform.current_stable" = "1.15.8"
  "toolchain.azure_cli.latest_tested" = "2.88.0"
  "toolchain.providers.azurerm" = "4.80.0"
  "toolchain.providers.random" = "3.9.0"
  "toolchain.providers.local" = "2.9.0"
  "toolchain.actions.checkout" = "v7"
  "toolchain.actions.setup_terraform" = "v4"
  "toolchain.actions.cache" = "v6"
}
foreach ($entry in $requiredMetadata.GetEnumerator()) {
  $actual = Get-CourseMetadataValue $metadata $entry.Key
  if ($actual -ne $entry.Value) {
    throw "Metadata '$($entry.Key)' expected '$($entry.Value)' but found '$actual'."
  }
}

$catalogPath = Join-Path $CourseRoot "shared\quality\exam-objectives.json"
if (-not (Test-Path -LiteralPath $catalogPath -PathType Leaf)) {
  throw "Missing machine-readable objective catalog: $catalogPath"
}
$catalog = Get-Content -LiteralPath $catalogPath -Raw | ConvertFrom-Json
if ($catalog.exam_code -ne "Terraform Associate 004" -or
    $catalog.product_version_tested -ne "1.12" -or
    $catalog.verified_on -ne "2026-07-10" -or
    $catalog.official_url -ne $requiredMetadata["certification.objectives_url"]) {
  throw "Objective catalog metadata does not match course-map.yml."
}
Assert-Equal "official objective count" @($catalog.objectives).Count $expectedObjectives.Count
foreach ($objectiveId in $expectedObjectives.Keys) {
  $matches = @($catalog.objectives | Where-Object { $_.id -eq $objectiveId })
  Assert-Equal "catalog entry count for $objectiveId" $matches.Count 1
  if ($matches[0].title -cne $expectedObjectives[$objectiveId]) {
    throw "Objective $objectiveId title must exactly match '$($expectedObjectives[$objectiveId])'."
  }
}
$topicText = @($catalog.additional_004_topics | ForEach-Object { "$($_.id) $($_.title)" }) -join [Environment]::NewLine
if ($topicText -notmatch '(?i)ephemeral' -or $topicText -notmatch '(?i)write-only') {
  throw "Catalog must list ephemeral values and write-only arguments as separate 004 topics."
}

$lessonRoot = Join-Path $CourseRoot "lessons"
$lessons = @(Get-ChildItem -LiteralPath $lessonRoot -Directory | Sort-Object Name)
Assert-Equal "lesson directory count" $lessons.Count 40
$courseMapContent = Get-Content -LiteralPath (Join-Path $CourseRoot "course-map.yml") -Raw
$lessonMapBlocks = [regex]::Matches($courseMapContent, '(?ms)^\s{2}- number:\s*(?<number>\d+)(?<body>.*?)(?=^\s{2}- number:|\z)')
Assert-Equal "course-map lesson entry count" $lessonMapBlocks.Count 40
$requiredSections = @(
  "## Certification alignment",
  "## Scenario",
  "## Walkthrough",
  "## Expected results",
  "## Failure modes",
  "## Cleanup",
  "## Check questions"
)

foreach ($lesson in $lessons) {
  if ($lesson.Name -notmatch '^(\d{2})-') {
    throw "Lesson folder must start with a two-digit number: $($lesson.Name)"
  }
  $lessonNumber = $Matches[1]
  $readme = Join-Path $lesson.FullName "README.md"
  $lab = Join-Path $lesson.FullName "lab"
  if (-not (Test-Path -LiteralPath $readme -PathType Leaf)) {
    throw "Missing README: $($lesson.Name)"
  }
  if (-not (Test-Path -LiteralPath $lab -PathType Container)) {
    throw "Missing lab folder: $($lesson.Name)"
  }
  $content = Get-Content -LiteralPath $readme -Raw
  foreach ($section in $requiredSections) {
    if ($content -notmatch "(?m)^$([regex]::Escape($section))\s*$") {
      throw "Missing section '$section' in $($lesson.Name)"
    }
  }
  foreach ($asset in @("assets/lesson-$lessonNumber-visual.svg", "assets/lesson-$lessonNumber-diagram.svg")) {
    if (-not (Test-Path -LiteralPath (Join-Path $lesson.FullName $asset) -PathType Leaf)) {
      throw "Missing lesson asset '$asset' in $($lesson.Name)"
    }
    if ($content -notmatch [regex]::Escape($asset)) {
      throw "README does not reference '$asset' in $($lesson.Name)"
    }
  }

  $mapBlock = @($lessonMapBlocks | Where-Object { [int]$_.Groups["number"].Value -eq [int]$lessonNumber })
  Assert-Equal "course-map entry count for lesson $lessonNumber" $mapBlock.Count 1
  $mapBody = $mapBlock[0].Groups["body"].Value
  if ($mapBody -notmatch '(?m)^\s+objectives:') {
    throw "Lesson $lessonNumber has no structured objective mapping."
  }
  $lessonIds = @(
    [regex]::Matches($mapBody, '\bid:\s*["'']?(?<id>[1-8][a-z])') |
      ForEach-Object { $_.Groups["id"].Value } |
      Sort-Object -Unique
  )
  if ($lessonIds.Count -eq 0) {
    throw "Lesson $lessonNumber has no objective IDs."
  }
  foreach ($objectiveId in $lessonIds) {
    if (-not $expectedObjectives.Contains($objectiveId)) {
      throw "Lesson $lessonNumber maps unknown objective '$objectiveId'."
    }
    if ($content -notmatch "(?<![A-Za-z0-9])$objectiveId(?![A-Za-z0-9])") {
      throw "Lesson $lessonNumber README does not evidence objective $objectiveId."
    }
  }
  $coverages = @(
    [regex]::Matches($mapBody, '\bcoverage:\s*["'']?(?<coverage>[a-z_]+)') |
      ForEach-Object { $_.Groups["coverage"].Value }
  )
  if ($coverages.Count -lt $lessonIds.Count) {
    throw "Lesson $lessonNumber must give every objective a coverage value."
  }
  foreach ($coverage in $coverages) {
    if ($coverage -notin @("hands_on", "guided", "conceptual")) {
      throw "Lesson $lessonNumber uses invalid coverage '$coverage'."
    }
  }
}

$mappedIds = @(
  [regex]::Matches($courseMapContent, '\bid:\s*["'']?(?<id>[1-8][a-z])') |
    ForEach-Object { $_.Groups["id"].Value } |
    Sort-Object -Unique
)
foreach ($objectiveId in $expectedObjectives.Keys) {
  if ($objectiveId -notin $mappedIds) {
    throw "Official objective $objectiveId is not mapped to a lesson."
  }
}

$primaryEvidenceIds = @(
  [regex]::Matches(
    $courseMapContent,
    '(?ms)- id:\s*["'']?(?<id>[1-8][a-z])["'']?\s+coverage:\s*["'']?(?:hands_on|guided)["'']?'
  ) |
    ForEach-Object { $_.Groups["id"].Value } |
    Sort-Object -Unique
)
foreach ($objectiveId in $expectedObjectives.Keys) {
  if ($objectiveId -notin $primaryEvidenceIds) {
    throw "Official objective $objectiveId has no hands-on or guided primary evidence."
  }
}

$questionBank = Get-Content -LiteralPath (Join-Path $CourseRoot "exam-review\practice-questions.md") -Raw
if ($questionBank -notmatch '(?m)^## Practice set A — Questions 01–30\s*$' -or
    $questionBank -notmatch '(?m)^## Practice set B — Questions 31–60\s*$') {
  throw "Question bank must contain the two 30-question sets."
}
$questions = [regex]::Matches($questionBank, '(?ms)^### Q(?<number>\d{2})\s+—.*?(?=^### Q\d{2}\s+—|\z)')
Assert-Equal "practice question count" $questions.Count 60
Assert-Equal "true/false question count" ([regex]::Matches($questionBank, '(?m)^- \*\*Format:\*\* \x60true_false\x60\s*$').Count) 10
Assert-Equal "single-choice question count" ([regex]::Matches($questionBank, '(?m)^- \*\*Format:\*\* \x60single_choice\x60\s*$').Count) 30
Assert-Equal "multiple-answer question count" ([regex]::Matches($questionBank, '(?m)^- \*\*Format:\*\* \x60multiple_answer\x60\s*$').Count) 20
$questionObjectiveIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($questionMatch in $questions) {
  $question = $questionMatch.Value
  foreach ($pattern in @(
    '(?m)^- \*\*Objective:\*\* \x60[1-8][a-z]\x60\s*$',
    '(?m)^- \*\*Format:\*\* \x60(?:true_false|single_choice|multiple_answer)\x60\s*$',
    '(?m)^- \*\*Select:\*\* \x60\d+\x60\s*$',
    '(?m)^- \*\*Lesson:\*\* \[Lesson \d{2}\]\(',
    '(?m)^- \*\*Official reference:\*\* \[',
    '\*\*Correct answer:\*\*',
    '\*\*Rationale:\*\*',
    '\*\*Distractor explanations:\*\*'
  )) {
    if ($question -notmatch $pattern) {
      throw "Question Q$($questionMatch.Groups['number'].Value) is missing required metadata or answer detail."
    }
  }
  $null = $question -match '(?m)^- \*\*Objective:\*\* \x60(?<id>[1-8][a-z])\x60\s*$'
  if (-not $expectedObjectives.Contains($Matches.id)) {
    throw "Question Q$($questionMatch.Groups['number'].Value) uses unknown objective '$($Matches.id)'."
  }
  [void]$questionObjectiveIds.Add($Matches.id)
}
foreach ($objectiveId in $expectedObjectives.Keys) {
  if (-not $questionObjectiveIds.Contains($objectiveId)) {
    throw "Question bank does not cover objective $objectiveId."
  }
}
foreach ($additionalTopic in @("004-ephemeral-values", "004-write-only-arguments")) {
  if ($questionBank -notmatch [regex]::Escape($additionalTopic)) {
    throw "Question bank does not tag additional topic $additionalTopic."
  }
}

$svgFiles = @(Get-ChildItem -LiteralPath $lessonRoot -Recurse -File -Filter "*.svg")
Assert-Equal "lesson SVG count" $svgFiles.Count 80
foreach ($svgFile in $svgFiles) {
  $svg = Get-Content -LiteralPath $svgFile.FullName -Raw
  if ($svg -notmatch '<title id="title">[^<]{12,}</title>' -or
      $svg -notmatch '<desc id="desc">[^<]{40,}</desc>') {
    throw "SVG needs a meaningful title and accessible description: $($svgFile.FullName)"
  }
  if ($svg -match 'A colorful Terraform lesson diagram|A lesson-specific Terraform and Azure') {
    throw "SVG still contains a boilerplate accessibility description: $($svgFile.FullName)"
  }
}

foreach ($marker in @(
  "StackSimplify", "Kalyan", "stacksimplify.com",
  "hashicorp-certified-terraform-associate-on-azure", "course-images",
  "terraform-azure.pem", "terraform-azure.pub", "az-service-principal"
)) {
  Assert-NoMatches $marker $marker
}

$versionFiles = @(Get-ChildItem -LiteralPath $CourseRoot -Recurse -File -Filter "versions.tf" |
  Where-Object { $_.FullName -notmatch '[\\/]\.terraform[\\/]' })
foreach ($versionFile in $versionFiles) {
  if ((Get-Content -LiteralPath $versionFile.FullName -Raw) -notmatch 'required_version\s*=\s*">= 1\.12\.0, < 2\.0\.0"') {
    throw "Incorrect Terraform core constraint in $($versionFile.FullName)."
  }
}

$terraformRoots = @(Get-TerraformRootDirectories -CourseRoot $CourseRoot)
foreach ($terraformRoot in $terraformRoots) {
  $versionsPath = Join-Path $terraformRoot "versions.tf"
  if (-not (Test-Path -LiteralPath $versionsPath -PathType Leaf)) {
    throw "Terraform root is missing versions.tf: $terraformRoot"
  }
  $versionsContent = Get-Content -LiteralPath $versionsPath -Raw
  $rootTerraform = @(
    Get-ChildItem -LiteralPath $terraformRoot -File -Filter "*.tf" |
      ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw }
  ) -join [Environment]::NewLine
  foreach ($provider in @(
    @{ Name = "azurerm"; Source = "hashicorp/azurerm"; Constraint = '~> 4\.80' },
    @{ Name = "random"; Source = "hashicorp/random"; Constraint = '~> 3\.9' },
    @{ Name = "local"; Source = "hashicorp/local"; Constraint = '~> 2\.9' }
  )) {
    if ($rootTerraform -match [regex]::Escape($provider.Source)) {
      $constraintPattern = 'version\s*=\s*"' + $provider.Constraint + '"'
      if ($versionsContent -notmatch $constraintPattern) {
        throw "Root provider $($provider.Name) has wrong constraint in $versionsPath."
      }
    }
  }
  if (-not $SkipLockCheck -and
      $versionsContent -match 'source\s*=\s*"hashicorp/' -and
      -not (Test-Path -LiteralPath (Join-Path $terraformRoot ".terraform.lock.hcl") -PathType Leaf)) {
    throw "External-provider root is missing its committed lock file: $terraformRoot"
  }
}

$moduleLockFiles = @(Get-ChildItem -LiteralPath (Join-Path $CourseRoot "shared\modules") -Recurse -Force -File -Filter ".terraform.lock.hcl")
if ($moduleLockFiles.Count -gt 0) {
  throw "Reusable child modules must not contain dependency lock files."
}
Assert-PathContains (Join-Path $CourseRoot ".gitignore") '(?m)^\*\*/\.terraform/$' "working-directory ignore rule"
if ((Get-Content -LiteralPath (Join-Path $CourseRoot ".gitignore") -Raw) -match '\.terraform\.lock\.hcl') {
  throw ".terraform.lock.hcl must not be ignored."
}
if ((Get-Content -LiteralPath (Join-Path $PSScriptRoot "cleanup-local-terraform.ps1") -Raw) -match '\.terraform\.lock\.hcl') {
  throw "Cleanup scripts must preserve dependency locks."
}

Assert-TreeContains (Join-Path $lessonRoot "05-providers-version-constraints-lock-files\lab") 'hashicorp/random' "external provider exercise"
Assert-TreeContains (Join-Path $lessonRoot "07-resources-data-sources-references\lab") 'data\s+"azurerm_' "Azure data source"
Assert-TreeContains (Join-Path $lessonRoot "12-sensitive-values-secret-handling\lab") '\bephemeral\b' "ephemeral handling"
Assert-TreeContains (Join-Path $lessonRoot "20-dynamic-blocks-optional-configuration\lab") 'dynamic\s+"security_rule"' "dynamic NSG rules"
Assert-TreeContains (Join-Path $lessonRoot "22-azure-remote-backend-storage-account\lab") 'backend\s+"azurerm"' "AzureRM backend"
Assert-TreeContains (Join-Path $lessonRoot "22-azure-remote-backend-storage-account") 'use_azuread_auth' "Entra ID backend auth"
Assert-TreeContains (Join-Path $lessonRoot "23-state-locking-drift-refresh-only-plans\lab") 'local_file' "local drift resource"
Assert-TreeContains (Join-Path $lessonRoot "24-state-inspection-import-moved-removed\lab") 'random_id' "importable random_id"
Assert-TreeContains (Join-Path $lessonRoot "24-state-inspection-import-moved-removed") '\bimport\s*\{' "import block"
Assert-TreeContains (Join-Path $lessonRoot "24-state-inspection-import-moved-removed") '\bmoved\s*\{' "moved block"
Assert-TreeContains (Join-Path $lessonRoot "24-state-inspection-import-moved-removed") '\bremoved\s*\{' "removed block"
Assert-TreeContains (Join-Path $lessonRoot "28-registry-modules-version-pinning\lab") 'hashicorp/subnets/cidr' "pinned registry module"
Assert-TreeContains (Join-Path $lessonRoot "36-debugging-logs-cli-config-provider-cache") 'TF_LOG_PATH' "debug log path"
Assert-TreeContains (Join-Path $lessonRoot "36-debugging-logs-cli-config-provider-cache") 'plugin_cache_dir' "provider cache config"
Assert-TreeContains (Join-Path $lessonRoot "11-validation-rules-custom-conditions\lab") 'expect_failures' "custom-condition Terraform tests"
Assert-TreeContains (Join-Path $lessonRoot "37-hcp-terraform-workflow-overview") 'cloud\s*\{' "optional HCP cloud integration"
Assert-TreeContains (Join-Path $lessonRoot "38-hcp-terraform-projects-workspaces-variables-runs") 'tfe_project' "HCP project exercise"
Assert-TreeContains (Join-Path $lessonRoot "38-hcp-terraform-projects-workspaces-variables-runs") 'tfe_variable_set' "HCP variable-set exercise"
Assert-TreeContains (Join-Path $lessonRoot "38-hcp-terraform-projects-workspaces-variables-runs") 'tfe_run_trigger' "HCP run-trigger exercise"
Assert-TreeContains (Join-Path $lessonRoot "38-hcp-terraform-projects-workspaces-variables-runs") 'terraform_remote_state' "HCP remote-state exercise"
Assert-TreeContains (Join-Path $lessonRoot "39-governance-drift-detection-policy-concepts") 'TFC_AZURE_PROVIDER_AUTH' "optional HCP Azure dynamic credentials"

$forbiddenFiles = @(Get-ChildItem -LiteralPath $CourseRoot -Recurse -Force -File |
  Where-Object {
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and
    $_.Name -match '\.(?:pem|tfstate)$|\.tfstate\.|\.tfplan$|^terraform\.tfvars$|^generated-runbook\.txt$|^terraform-debug.*\.log$'
  })
if ($forbiddenFiles.Count -gt 0) {
  $forbiddenFiles | ForEach-Object { Write-Host $_.FullName }
  throw "Forbidden generated, state, plan, key, or debug-log files found."
}
$terraformDirs = @(Get-ChildItem -LiteralPath $CourseRoot -Recurse -Force -Directory |
  Where-Object { $_.Name -eq ".terraform" -and $_.FullName -notmatch '[\\/]\.git[\\/]' })
if ($terraformDirs.Count -gt 0) {
  throw "Terraform working directories should not be committed or left by validation."
}

Invoke-CourseNative terraform fmt -check -recursive $CourseRoot
if (-not $SkipTerraformInit) {
  $parameters = @{ CourseRoot = $CourseRoot; PluginCacheDir = $PluginCacheDir; SkipFormat = $true }
  & (Join-Path $PSScriptRoot "Test-TerraformLabs.ps1") @parameters

  foreach ($exercise in @(
    "lessons\23-state-locking-drift-refresh-only-plans\exercise\Invoke-DriftAndLockDemo.ps1",
    "lessons\24-state-inspection-import-moved-removed\exercise\Invoke-StateLifecycleDemo.ps1",
    "lessons\36-debugging-logs-cli-config-provider-cache\exercise\Invoke-DebugDemo.ps1"
  )) {
    $exercisePath = Join-Path $CourseRoot $exercise
    if (-not (Test-Path -LiteralPath $exercisePath -PathType Leaf)) {
      throw "Missing disposable workflow exercise: $exercise"
    }
    & $exercisePath
  }
}
$remainingTerraformDirs = @(Get-ChildItem -LiteralPath $CourseRoot -Recurse -Force -Directory |
  Where-Object { $_.Name -eq ".terraform" -and $_.FullName -notmatch '[\\/]\.git[\\/]' })
if ($remainingTerraformDirs.Count -gt 0) {
  throw "Validation was not idempotent: generated .terraform directories remain."
}

Write-Host "Course quality gates passed for $($lessons.Count) lessons and $($expectedObjectives.Count) objectives."
