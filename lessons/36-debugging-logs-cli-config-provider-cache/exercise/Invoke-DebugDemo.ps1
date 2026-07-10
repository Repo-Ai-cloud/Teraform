[CmdletBinding()]
param(
    [ValidateSet('DEBUG', 'TRACE')]
    [string]$LogLevel = 'DEBUG'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lessonRoot = Split-Path -Parent $PSScriptRoot
$labRoot = Join-Path $lessonRoot 'lab'
$temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("terraform-lesson-36-{0}" -f [guid]::NewGuid().ToString('N'))
$pluginCache = Join-Path $temporaryRoot 'plugin-cache'
$cliConfig = Join-Path $temporaryRoot 'terraform.rc'
$logPath = Join-Path $temporaryRoot 'terraform-debug.log'
$locationPushed = $false

function Assert-DisposablePath {
    param([Parameter(Mandatory)][string]$Path)

    $tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    $resolvedPath = [System.IO.Path]::GetFullPath($Path)
    if (-not $resolvedPath.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to delete a path outside the OS temp directory: $resolvedPath"
    }
}

$previousEnvironment = @{
    TF_CLI_CONFIG_FILE = [Environment]::GetEnvironmentVariable('TF_CLI_CONFIG_FILE', 'Process')
    TF_LOG             = [Environment]::GetEnvironmentVariable('TF_LOG', 'Process')
    TF_LOG_PATH        = [Environment]::GetEnvironmentVariable('TF_LOG_PATH', 'Process')
}

function Invoke-Terraform {
    param([Parameter(Mandatory)][string[]]$Arguments)

    & terraform @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "terraform $($Arguments -join ' ') failed with exit code $LASTEXITCODE."
    }
}

try {
    New-Item -ItemType Directory -Path $temporaryRoot, $pluginCache -Force | Out-Null
    Copy-Item -Path (Join-Path $labRoot '*.tf') -Destination $temporaryRoot
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'provider-cache.tf.example') -Destination (Join-Path $temporaryRoot 'provider-cache.tf')

    $portableCachePath = $pluginCache.Replace('\', '/')
    $cliConfigLines = @(
        "plugin_cache_dir = `"$portableCachePath`""
        'disable_checkpoint = true'
    )
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($cliConfig, $cliConfigLines, $utf8WithoutBom)

    $env:TF_CLI_CONFIG_FILE = $cliConfig
    $env:TF_LOG = $LogLevel
    $env:TF_LOG_PATH = $logPath

    Push-Location $temporaryRoot
    $locationPushed = $true

    Invoke-Terraform -Arguments @('init', '-input=false', '-no-color')
    Invoke-Terraform -Arguments @('validate', '-no-color')

    $cachedProviders = @(Get-ChildItem -LiteralPath $pluginCache -Recurse -File)
    if ($cachedProviders.Count -eq 0) {
        throw 'Terraform did not populate the disposable provider cache.'
    }

    if (-not (Test-Path -LiteralPath $logPath)) {
        throw 'Terraform did not create the requested diagnostic log.'
    }

    $rawLog = Get-Content -LiteralPath $logPath -Raw
    $redactedLog = $rawLog `
        -replace '(?im)(authorization|password|secret|token)(\s*[=:]\s*)[^\s,;]+', '$1$2[REDACTED]' `
        -replace '(?im)(client_secret|access_key|sas_token)(\s*[=:]\s*)[^\s,;]+', '$1$2[REDACTED]'

    Write-Host 'Redacted diagnostic sample (first 12 lines):'
    $redactedLog -split "`r?`n" | Select-Object -First 12 | ForEach-Object { Write-Host $_ }
    Write-Host "Cached provider files: $($cachedProviders.Count)"
}
finally {
    if ($locationPushed) {
        Pop-Location
    }

    foreach ($name in $previousEnvironment.Keys) {
        [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name], 'Process')
    }

    if (Test-Path -LiteralPath $temporaryRoot) {
        Assert-DisposablePath -Path $temporaryRoot
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}

Write-Host 'Lesson 36 completed; diagnostic logs, provider cache, CLI config, and temporary state were removed.'
