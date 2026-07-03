param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [string]$PluginCacheDir = (Join-Path $env:TEMP "tf-plugin-cache-atfa40")
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

New-Item -ItemType Directory -Force -Path $PluginCacheDir | Out-Null
$env:TF_PLUGIN_CACHE_DIR = $PluginCacheDir

Invoke-Native terraform fmt -check -recursive $CourseRoot

$labs = Get-ChildItem -Path (Join-Path $CourseRoot "lessons") -Directory |
  Sort-Object Name |
  ForEach-Object { Join-Path $_.FullName "lab" } |
  Where-Object { Test-Path $_ }

foreach ($lab in $labs) {
  Write-Host "Validating $lab"
  Push-Location $lab
  try {
    Invoke-Native terraform init -backend=false -input=false
    Invoke-Native terraform validate
  }
  finally {
    Pop-Location
  }
}
