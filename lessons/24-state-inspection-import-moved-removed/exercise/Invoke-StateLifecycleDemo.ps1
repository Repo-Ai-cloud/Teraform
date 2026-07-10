[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$stagesRoot = Join-Path $PSScriptRoot 'stages'
$temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("terraform-lesson-24-{0}" -f [guid]::NewGuid().ToString('N'))
$locationPushed = $false

function Assert-DisposablePath {
    param([Parameter(Mandatory)][string]$Path)

    $tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    $resolvedPath = [System.IO.Path]::GetFullPath($Path)
    if (-not $resolvedPath.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to delete a path outside the OS temp directory: $resolvedPath"
    }
}

function Invoke-Terraform {
    param([Parameter(Mandatory)][string[]]$Arguments)

    & terraform @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "terraform $($Arguments -join ' ') failed with exit code $LASTEXITCODE."
    }
}

function Set-Stage {
    param([Parameter(Mandatory)][string]$Name)

    Copy-Item -LiteralPath (Join-Path $stagesRoot $Name) -Destination (Join-Path $temporaryRoot 'main.tf') -Force
    Invoke-Terraform -Arguments @('fmt', '-check')
}

try {
    New-Item -ItemType Directory -Path $temporaryRoot -Force | Out-Null
    Push-Location $temporaryRoot
    $locationPushed = $true

    Set-Stage -Name '01-import.tf.example'
    Invoke-Terraform -Arguments @('init', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('plan', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('apply', '-auto-approve', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('state', 'list')
    Invoke-Terraform -Arguments @('state', 'show', 'random_id.legacy')

    Set-Stage -Name '02-moved.tf.example'
    Invoke-Terraform -Arguments @('plan', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('apply', '-auto-approve', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('state', 'list')
    Invoke-Terraform -Arguments @('state', 'show', 'random_id.service')

    Set-Stage -Name '03-removed.tf.example'
    Invoke-Terraform -Arguments @('plan', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('apply', '-auto-approve', '-input=false', '-no-color')

    $remainingAddresses = (& terraform state list 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw 'terraform state list failed after the removed block was applied.'
    }
    if ($remainingAddresses) {
        throw "Expected an empty state after the removed block; found: $remainingAddresses"
    }
    Write-Host 'Import, state inspection, moved, and removed stages all completed successfully.'
}
finally {
    if ($locationPushed) {
        Pop-Location
    }
    if (Test-Path -LiteralPath $temporaryRoot) {
        Assert-DisposablePath -Path $temporaryRoot
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}

Write-Host 'Lesson 24 completed; the disposable working directory and generated state were removed.'
