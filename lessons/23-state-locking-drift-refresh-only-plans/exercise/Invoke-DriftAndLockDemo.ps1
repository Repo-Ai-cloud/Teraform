[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lessonRoot = Split-Path -Parent $PSScriptRoot
$labRoot = Join-Path $lessonRoot 'lab'
$temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("terraform-lesson-23-{0}" -f [guid]::NewGuid().ToString('N'))
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

try {
    New-Item -ItemType Directory -Path $temporaryRoot -Force | Out-Null
    Copy-Item -Path (Join-Path $labRoot '*.tf') -Destination $temporaryRoot

    Push-Location $temporaryRoot
    $locationPushed = $true

    Invoke-Terraform -Arguments @('init', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('apply', '-auto-approve', '-input=false', '-no-color')

    $driftTarget = Join-Path $temporaryRoot 'generated/drift-demo.txt'
    Set-Content -LiteralPath $driftTarget -Value 'changed outside Terraform - intentional drift' -Encoding utf8

    & terraform plan -refresh-only -detailed-exitcode -input=false -no-color
    $driftExitCode = $LASTEXITCODE
    if ($driftExitCode -ne 2) {
        throw "Expected the refresh-only plan to report drift with exit code 2; received $driftExitCode."
    }
    Write-Host 'Refresh-only plan detected the intentional local-file drift.'

    # Hold the local state file with an exclusive OS handle to simulate another
    # state writer. Terraform's next command must refuse to acquire the lock.
    $statePath = Join-Path $temporaryRoot 'terraform.tfstate'
    $stateHandle = [System.IO.File]::Open(
        $statePath,
        [System.IO.FileMode]::Open,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::None
    )
    try {
        $previousErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            $lockAttempt = (& terraform plan -lock-timeout=1s -input=false -no-color 2>&1 | Out-String)
            $lockExitCode = $LASTEXITCODE
        }
        finally {
            $ErrorActionPreference = $previousErrorActionPreference
        }
    }
    finally {
        $stateHandle.Dispose()
    }
    if ($lockExitCode -eq 0 -or $lockAttempt -notmatch 'state lock') {
        throw 'Expected Terraform to reject the plan while the local state file was exclusively locked.'
    }
    Write-Host 'Terraform safely rejected a concurrent operation while the local state lock was held.'
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

Write-Host 'Lesson 23 completed; the disposable working directory and generated state were removed.'
$global:LASTEXITCODE = 0
