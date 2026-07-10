[CmdletBinding()]
param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [string]$PluginCacheDir = (Join-Path $env:TEMP "tf-plugin-cache-atfa40"),
  [switch]$SkipFormat,
  [switch]$SkipTerraformTest
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "CourseMetadata.ps1")

if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
  throw "Terraform CLI was not found on PATH."
}

$terraformRoots = @(Get-TerraformRootDirectories -CourseRoot $CourseRoot)
if ($terraformRoots.Count -lt 40) {
  throw "Expected at least 40 Terraform lab roots but found $($terraformRoots.Count)."
}

$previousPluginCache = [Environment]::GetEnvironmentVariable("TF_PLUGIN_CACHE_DIR", "Process")
New-Item -ItemType Directory -Force -Path $PluginCacheDir | Out-Null
$env:TF_PLUGIN_CACHE_DIR = $PluginCacheDir

try {
  if (-not $SkipFormat) {
    Invoke-CourseNative terraform fmt -check -recursive $CourseRoot
  }

  foreach ($terraformRoot in $terraformRoots) {
    $relativeRoot = [System.IO.Path]::GetRelativePath($CourseRoot, $terraformRoot)
    Write-Host "Validating $relativeRoot"
    Push-Location $terraformRoot
    try {
      Invoke-CourseNative terraform init -backend=false -input=false -lockfile=readonly -no-color
      Invoke-CourseNative terraform validate -no-color

      if (-not $SkipTerraformTest -and
          @(Get-ChildItem -LiteralPath $terraformRoot -Recurse -File -Filter "*.tftest.hcl").Count -gt 0) {
        Invoke-CourseNative terraform test -no-color
      }
    }
    finally {
      Pop-Location
      $workingDirectory = Join-Path $terraformRoot ".terraform"
      if (Test-Path -LiteralPath $workingDirectory) {
        Remove-Item -LiteralPath $workingDirectory -Recurse -Force
      }
    }
  }
}
finally {
  foreach ($terraformRoot in $terraformRoots) {
    $workingDirectory = Join-Path $terraformRoot ".terraform"
    if (Test-Path -LiteralPath $workingDirectory) {
      Remove-Item -LiteralPath $workingDirectory -Recurse -Force
    }
  }

  if ($null -eq $previousPluginCache) {
    Remove-Item Env:TF_PLUGIN_CACHE_DIR -ErrorAction SilentlyContinue
  }
  else {
    $env:TF_PLUGIN_CACHE_DIR = $previousPluginCache
  }
}

Write-Host "Terraform validation passed for $($terraformRoots.Count) roots."
