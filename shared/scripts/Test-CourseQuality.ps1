param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [string]$PluginCacheDir = (Join-Path $env:TEMP "tf-plugin-cache-atfa40"),
  [switch]$SkipTerraformInit
)

$ErrorActionPreference = "Stop"

function Invoke-Native {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
  )

  & $Command @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "$Command $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
  }
}

function Assert-Equal {
  param(
    [string]$Name,
    [int]$Actual,
    [int]$Expected
  )

  if ($Actual -ne $Expected) {
    throw "$Name expected $Expected but found $Actual"
  }
}

function Assert-NoMatches {
  param(
    [string]$Pattern,
    [string]$Description
  )

  $files = Get-ChildItem -Path $CourseRoot -Recurse -File |
    Where-Object {
      $_.Name -ne "Test-CourseQuality.ps1" -and
      $_.Name -ne ".terraform.lock.hcl" -and
      $_.FullName -notmatch "[\\/](\.git|\.terraform)[\\/]"
    }

  $matches = $files | Select-String -Pattern $Pattern -SimpleMatch
  if ($matches) {
    $matches | ForEach-Object {
      Write-Host "$($_.Path):$($_.LineNumber):$($_.Line)"
    }
    throw "Found forbidden marker: $Description"
  }
}

function Assert-CourseContains {
  param(
    [object[]]$Files,
    [string]$Pattern,
    [string]$Description
  )

  $matches = $Files | Select-String -Pattern $Pattern -SimpleMatch
  if (-not $matches) {
    throw "Missing Terraform Associate 004 coverage marker: $Description"
  }
}

$lessonRoot = Join-Path $CourseRoot "lessons"
$lessons = Get-ChildItem -Path $lessonRoot -Directory | Sort-Object Name
Assert-Equal -Name "lesson directory count" -Actual $lessons.Count -Expected 40

$requiredSections = @(
  "## Objectives",
  "## Scenario",
  "## Walkthrough",
  "## Wiki",
  "## Lab Steps",
  "## Azure Design Notes",
  "## Quality Review",
  "## Cleanup",
  "## Check Questions"
)

foreach ($lesson in $lessons) {
  $readme = Join-Path $lesson.FullName "README.md"
  $lab = Join-Path $lesson.FullName "lab"

  if (-not (Test-Path $readme)) {
    throw "Missing README: $($lesson.Name)"
  }

  if (-not (Test-Path $lab)) {
    throw "Missing lab folder: $($lesson.Name)"
  }

  $content = Get-Content $readme -Raw
  foreach ($section in $requiredSections) {
    if ($content -notmatch [regex]::Escape($section)) {
      throw "Missing section '$section' in $($lesson.Name)"
    }
  }

  if ($lesson.Name -notmatch "^(\d{2})-") {
    throw "Lesson folder must start with a two-digit lesson number: $($lesson.Name)"
  }

  $lessonNumber = $Matches[1]
  $expectedAssets = @(
    "assets/lesson-$lessonNumber-visual.svg",
    "assets/lesson-$lessonNumber-diagram.svg"
  )

  foreach ($expectedAsset in $expectedAssets) {
    $expectedAssetPath = Join-Path $lesson.FullName $expectedAsset

    if (-not (Test-Path $expectedAssetPath)) {
      throw "Missing lesson asset '$expectedAsset' in $($lesson.Name)"
    }

    if ($content -notmatch [regex]::Escape($expectedAsset)) {
      throw "README does not reference lesson asset '$expectedAsset' in $($lesson.Name)"
    }
  }
}

$forbiddenMarkers = @(
  "StackSimplify",
  "Kalyan",
  "stacksimplify.com",
  "hashicorp-certified-terraform-associate-on-azure",
  "course-images",
  "terraform-azure.pem",
  "terraform-azure.pub",
  "az-service-principal"
)

foreach ($marker in $forbiddenMarkers) {
  Assert-NoMatches -Pattern $marker -Description $marker
}

$coverageFiles = @(
  Get-ChildItem -Path (Join-Path $CourseRoot "lessons") -Recurse -File
  Get-ChildItem -Path (Join-Path $CourseRoot "exam-review") -Recurse -File
  Get-Item -Path (Join-Path $CourseRoot "README.md")
  Get-Item -Path (Join-Path $CourseRoot "course-map.yml")
)

$coverageMarkers = @(
  @{ Pattern = "Terraform Associate 004"; Description = "current exam version" },
  @{ Pattern = "Terraform 1.12"; Description = "tested Terraform version" },
  @{ Pattern = "depends_on"; Description = "explicit dependencies" },
  @{ Pattern = "create_before_destroy"; Description = "replacement lifecycle rule" },
  @{ Pattern = "precondition"; Description = "custom preconditions" },
  @{ Pattern = "postcondition"; Description = "custom postconditions" },
  @{ Pattern = "check"; Description = "configuration checks" },
  @{ Pattern = "Vault"; Description = "secret manager awareness" },
  @{ Pattern = "ephemeral"; Description = "ephemeral value awareness" },
  @{ Pattern = "write-only"; Description = "write-only argument awareness" },
  @{ Pattern = "HCP Terraform"; Description = "HCP Terraform coverage" },
  @{ Pattern = "projects"; Description = "HCP Terraform projects" },
  @{ Pattern = "workspaces"; Description = "HCP Terraform workspaces" },
  @{ Pattern = "variable sets"; Description = "HCP Terraform variable sets" },
  @{ Pattern = "run triggers"; Description = "HCP Terraform run triggers" },
  @{ Pattern = "drift detection"; Description = "HCP Terraform drift detection" },
  @{ Pattern = "policy checks"; Description = "HCP Terraform policy checks" },
  @{ Pattern = "8d Configure and use HCP Terraform integration"; Description = "granular objective 8d mapping" }
)

foreach ($marker in $coverageMarkers) {
  Assert-CourseContains -Files $coverageFiles -Pattern $marker.Pattern -Description $marker.Description
}

$forbiddenFiles = Get-ChildItem $CourseRoot -Recurse -Force -File |
  Where-Object {
    $_.Name -match "\.(pem|tfstate)$|\.tfstate\.|\.tfplan$|terraform\.tfvars$|generated-runbook\.txt$"
  }

if ($forbiddenFiles) {
  $forbiddenFiles | Select-Object -ExpandProperty FullName | ForEach-Object { Write-Host $_ }
  throw "Forbidden generated, state, plan, or key files found"
}

$terraformDirs = Get-ChildItem $CourseRoot -Recurse -Force -Directory |
  Where-Object { $_.Name -eq ".terraform" }

if ($terraformDirs) {
  $terraformDirs | Select-Object -ExpandProperty FullName | ForEach-Object { Write-Host $_ }
  throw "Terraform working directories should not be committed"
}

Invoke-Native terraform fmt -check -recursive $CourseRoot

if (-not $SkipTerraformInit) {
  New-Item -ItemType Directory -Force -Path $PluginCacheDir | Out-Null
  $env:TF_PLUGIN_CACHE_DIR = $PluginCacheDir

  foreach ($lesson in $lessons) {
    $lab = Join-Path $lesson.FullName "lab"
    Write-Host "Validating $($lesson.Name)"
    Push-Location $lab
    try {
      Invoke-Native terraform init -backend=false -input=false -no-color
      Invoke-Native terraform validate -no-color
    }
    finally {
      Pop-Location
    }
  }
}

Write-Host "Course quality gates passed for $($lessons.Count) lessons."

