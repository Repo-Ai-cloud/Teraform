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

  $matches = rg -n -i --fixed-strings $Pattern $CourseRoot --glob "!**/Test-CourseQuality.ps1"
  if ($LASTEXITCODE -eq 0) {
    $matches | ForEach-Object { Write-Host $_ }
    throw "Found forbidden marker: $Description"
  }
}

$lessonRoot = Join-Path $CourseRoot "lessons"
$lessons = Get-ChildItem -Path $lessonRoot -Directory | Sort-Object Name
Assert-Equal -Name "lesson directory count" -Actual $lessons.Count -Expected 40

$requiredSections = @(
  "## Objectives",
  "## Scenario",
  "## Walkthrough",
  "## Lab Steps",
  "## Azure Design Notes",
  "## MVP Review",
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
