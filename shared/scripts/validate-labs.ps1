[CmdletBinding()]
param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [string]$PluginCacheDir = (Join-Path $env:TEMP "tf-plugin-cache-atfa40"),
  [switch]$SkipTerraformTest
)

$ErrorActionPreference = "Stop"
$parameters = @{
  CourseRoot        = $CourseRoot
  PluginCacheDir    = $PluginCacheDir
  SkipTerraformTest = $SkipTerraformTest
}

& (Join-Path $PSScriptRoot "Test-TerraformLabs.ps1") @parameters
