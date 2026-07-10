[CmdletBinding()]
param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [switch]$SkipRemoteChecks
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "CourseMetadata.ps1")

$metadata = Get-CourseMetadata -CourseRoot $CourseRoot
$drift = [System.Collections.Generic.List[string]]::new()
$webHeaders = @{ "User-Agent" = "terraform-associate-azure-course-freshness" }

function Assert-RecordedValue {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [Parameter(Mandatory = $true)]
    [string]$Expected
  )

  $actual = Get-CourseMetadataValue $metadata $Path
  if ($actual -ne $Expected) {
    $drift.Add("$Path records '$actual'; expected '$Expected'.")
  }
}

function Get-LatestProviderVersion {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name
  )

  $response = Invoke-RestMethod -Uri "https://registry.terraform.io/v1/providers/hashicorp/$Name" -Headers $webHeaders
  return [string](
    $response.versions |
      Where-Object { $_ -match '^\d+\.\d+\.\d+$' } |
      Sort-Object { [version]$_ } -Descending |
      Select-Object -First 1
  )
}

function Get-LatestGitHubReleaseTag {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Repository
  )

  $headers = @{
    "Accept"     = "application/vnd.github+json"
    "User-Agent" = "terraform-associate-azure-course-freshness"
  }
  if ($env:GITHUB_TOKEN) {
    $headers.Authorization = "Bearer $($env:GITHUB_TOKEN)"
  }

  return [string](Invoke-RestMethod -Uri "https://api.github.com/repos/$Repository/releases/latest" -Headers $headers).tag_name
}

Assert-RecordedValue "certification.exam_code" "Terraform Associate 004"
Assert-RecordedValue "certification.status" "current"
Assert-RecordedValue "certification.verified_on" "2026-07-10"
Assert-RecordedValue "certification.product_version_tested" "1.12"
Assert-RecordedValue "certification.certification_url" "https://developer.hashicorp.com/certifications/infrastructure-automation"
Assert-RecordedValue "certification.prep_collection_url" "https://developer.hashicorp.com/terraform/tutorials/certification-004"
Assert-RecordedValue "certification.learning_path_url" "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-study-004"
Assert-RecordedValue "certification.objectives_url" "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004"
Assert-RecordedValue "certification.sample_questions_url" "https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-questions-004"
Assert-RecordedValue "toolchain.verified_on" "2026-07-10"
Assert-RecordedValue "toolchain.terraform.required_version" ">= 1.12.0, < 2.0.0"
Assert-RecordedValue "toolchain.terraform.exam_baseline" "1.12.0"
Assert-RecordedValue "toolchain.terraform.current_stable" "1.15.8"
Assert-RecordedValue "toolchain.azure_cli.latest_tested" "2.88.0"
Assert-RecordedValue "toolchain.providers.azurerm" "4.80.0"
Assert-RecordedValue "toolchain.providers.random" "3.9.0"
Assert-RecordedValue "toolchain.providers.local" "2.9.0"
Assert-RecordedValue "toolchain.actions.checkout" "v7"
Assert-RecordedValue "toolchain.actions.setup_terraform" "v4"
Assert-RecordedValue "toolchain.actions.cache" "v6"

$workflowPath = Join-Path $CourseRoot ".github\workflows\terraform-labs.yml"
$workflow = Get-Content -LiteralPath $workflowPath -Raw
foreach ($action in @(
  @{ Reference = "actions/checkout@v7"; Name = "checkout" },
  @{ Reference = "hashicorp/setup-terraform@v4"; Name = "setup-terraform" },
  @{ Reference = "actions/cache@v6"; Name = "cache" }
)) {
  if ($workflow -notmatch [regex]::Escape($action.Reference)) {
    $drift.Add("terraform-labs.yml does not use recorded $($action.Name) action '$($action.Reference)'.")
  }
}

if (-not $SkipRemoteChecks) {
  try {
    $certificationPage = (Invoke-WebRequest -Uri (Get-CourseMetadataValue $metadata "certification.certification_url") -Headers $webHeaders).Content
    if ($certificationPage -notmatch 'Terraform Associate[\s\S]{0,500}\(004\)') {
      $drift.Add("The official certification page no longer presents Terraform Associate 004 as current.")
    }
    if ($certificationPage -notmatch 'Terraform 1\.12') {
      $drift.Add("The official certification page no longer records Terraform 1.12 as the tested product version.")
    }
  }
  catch {
    $drift.Add("Could not verify the official certification page: $($_.Exception.Message)")
  }

  try {
    $objectivesPage = (Invoke-WebRequest -Uri (Get-CourseMetadataValue $metadata "certification.objectives_url") -Headers $webHeaders).Content
    if ($objectivesPage -notmatch '4h[\s\S]{0,500}Understand best practices for managing sensitive data, including secrets management with Vault') {
      $drift.Add("Official objective 4h wording has changed.")
    }
  }
  catch {
    $drift.Add("Could not verify the official objective page: $($_.Exception.Message)")
  }

  try {
    $terraformRelease = Invoke-RestMethod -Uri "https://checkpoint-api.hashicorp.com/v1/check/terraform" -Headers $webHeaders
    $latestTerraform = [string]$terraformRelease.current_version
    $recordedTerraform = Get-CourseMetadataValue $metadata "toolchain.terraform.current_stable"
    if ($latestTerraform -ne $recordedTerraform) {
      $drift.Add("Latest stable Terraform is $latestTerraform; course records $recordedTerraform.")
    }
  }
  catch {
    $drift.Add("Could not check the latest Terraform release: $($_.Exception.Message)")
  }

  foreach ($provider in @("azurerm", "random", "local")) {
    try {
      $latestProvider = Get-LatestProviderVersion $provider
      $recordedProvider = Get-CourseMetadataValue $metadata "toolchain.providers.$provider"
      if ($latestProvider -ne $recordedProvider) {
        $drift.Add("Latest hashicorp/$provider provider is $latestProvider; course records $recordedProvider.")
      }
    }
    catch {
      $drift.Add("Could not check hashicorp/$provider releases: $($_.Exception.Message)")
    }
  }

  try {
    $latestAzureCliTag = Get-LatestGitHubReleaseTag "Azure/azure-cli"
    $latestAzureCli = $latestAzureCliTag -replace '^azure-cli-', ''
    $recordedAzureCli = Get-CourseMetadataValue $metadata "toolchain.azure_cli.latest_tested"
    if ($latestAzureCli -ne $recordedAzureCli) {
      $drift.Add("Latest Azure CLI is $latestAzureCli; course records $recordedAzureCli.")
    }
  }
  catch {
    $drift.Add("Could not check Azure CLI releases: $($_.Exception.Message)")
  }

  foreach ($action in @(
    @{ Repository = "actions/checkout"; Metadata = "checkout" },
    @{ Repository = "hashicorp/setup-terraform"; Metadata = "setup_terraform" },
    @{ Repository = "actions/cache"; Metadata = "cache" }
  )) {
    try {
      $tag = Get-LatestGitHubReleaseTag $action.Repository
      if ($tag -notmatch '^v(?<major>\d+)') {
        throw "Unexpected release tag '$tag'."
      }
      $latestMajor = "v$($Matches.major)"
      $recordedMajor = Get-CourseMetadataValue $metadata "toolchain.actions.$($action.Metadata)"
      if ($latestMajor -ne $recordedMajor) {
        $drift.Add("Latest $($action.Repository) major is $latestMajor ($tag); course records $recordedMajor.")
      }
    }
    catch {
      $drift.Add("Could not check $($action.Repository) releases: $($_.Exception.Message)")
    }
  }
}

if ($drift.Count -gt 0) {
  $drift | ForEach-Object { Write-Error $_ -ErrorAction Continue }
  throw "Course freshness check found $($drift.Count) drift item(s). It did not modify the course or exam baseline."
}

Write-Host "Course certification and toolchain metadata are current."
