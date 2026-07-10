param(
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
)

$ErrorActionPreference = "Stop"

Get-ChildItem -Path $CourseRoot -Directory -Recurse -Force -Filter ".terraform" |
  ForEach-Object {
    Remove-Item -LiteralPath $_.FullName -Recurse -Force
  }
