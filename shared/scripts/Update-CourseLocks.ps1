[CmdletBinding()]
param(
  [switch]$Check,
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path,
  [string]$PluginCacheDir = (Join-Path $env:TEMP "tf-plugin-cache-atfa40")
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "CourseMetadata.ps1")

$platforms = @(
  "windows_amd64",
  "linux_amd64",
  "darwin_amd64",
  "darwin_arm64"
)

function Copy-CourseLockInputs {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Source,
    [Parameter(Mandatory = $true)]
    [string]$Destination
  )

  New-Item -ItemType Directory -Force -Path $Destination | Out-Null
  foreach ($topLevelDirectory in @("lessons", "shared")) {
    $sourceDirectory = Join-Path $Source $topLevelDirectory
    foreach ($file in Get-ChildItem -LiteralPath $sourceDirectory -Recurse -Force -File) {
      if ($file.Name -eq ".terraform.lock.hcl" -or
          $file.FullName -match '[\\/]\.terraform[\\/]' -or
          $file.Name -match '\.(?:tfstate|tfplan)$' -or
          $file.Name -match '\.tfstate\.') {
        continue
      }

      $relativePath = [System.IO.Path]::GetRelativePath($Source, $file.FullName)
      $destinationPath = Join-Path $Destination $relativePath
      New-Item -ItemType Directory -Force -Path (Split-Path $destinationPath -Parent) | Out-Null
      Copy-Item -LiteralPath $file.FullName -Destination $destinationPath
    }
  }
}

function Update-LocksAtRoot {
  param(
    [Parameter(Mandatory = $true)]
    [string]$WorkingCourseRoot
  )

  $terraformRoots = @(Get-TerraformRootDirectories -CourseRoot $WorkingCourseRoot)
  # Many lessons intentionally share the same provider selections. Lock every
  # unique selection once, then reuse the resulting cross-platform lock content
  # for equivalent roots. This keeps a full-course refresh fast without changing
  # the dependency decision Terraform made for any root.
  $lockBySelection = @{}
  foreach ($terraformRoot in $terraformRoots) {
    $rootConfiguration = @(
      Get-ChildItem -LiteralPath $terraformRoot -File -Filter "*.tf" |
        ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw }
    ) -join [Environment]::NewLine
    $hasProvider = $rootConfiguration -match 'source\s*=\s*"[^"]+/[^"]+"'
    $hasRegistryModule = $rootConfiguration -match '(?ms)module\s+"[^"]+"\s*\{.*?source\s*=\s*"(?!\.{1,2}/)'
    if (-not $hasProvider -and -not $hasRegistryModule) {
      continue
    }

    $relativeRoot = [System.IO.Path]::GetRelativePath($WorkingCourseRoot, $terraformRoot)
    Write-Host "Updating dependency selections for $relativeRoot"
    Push-Location $terraformRoot
    try {
      Invoke-CourseNative terraform init -backend=false -input=false -upgrade -no-color
      $lockPath = Join-Path $terraformRoot ".terraform.lock.hcl"
      if (-not (Test-Path -LiteralPath $lockPath -PathType Leaf)) {
        throw "Terraform did not create a dependency lock for $relativeRoot."
      }

      $initialLock = Get-Content -LiteralPath $lockPath -Raw
      $selectionParts = @(
        [regex]::Matches(
          $initialLock,
          '(?ms)^provider\s+"([^"]+)"\s*\{\s*version\s*=\s*"([^"]+)"(?:\s*constraints\s*=\s*"([^"]*)")?'
        ) | ForEach-Object {
          '{0}|{1}|{2}' -f $_.Groups[1].Value, $_.Groups[2].Value, $_.Groups[3].Value
        } | Sort-Object
      )
      if ($selectionParts.Count -eq 0) {
        throw "Could not identify provider selections in $lockPath."
      }
      $selectionKey = $selectionParts -join [Environment]::NewLine

      if ($lockBySelection.ContainsKey($selectionKey)) {
        Set-Content -LiteralPath $lockPath -Value $lockBySelection[$selectionKey] -NoNewline
        Write-Host "Reused cross-platform checksums for $relativeRoot"
      }
      else {
        $lockArguments = @("providers", "lock", "-enable-plugin-cache")
        foreach ($platform in $platforms) {
          $lockArguments += "-platform=$platform"
        }
        Invoke-CourseNative terraform @lockArguments
        $lockBySelection[$selectionKey] = Get-Content -LiteralPath $lockPath -Raw
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

if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
  throw "Terraform CLI was not found on PATH."
}

$previousPluginCache = [Environment]::GetEnvironmentVariable("TF_PLUGIN_CACHE_DIR", "Process")
New-Item -ItemType Directory -Force -Path $PluginCacheDir | Out-Null
$env:TF_PLUGIN_CACHE_DIR = $PluginCacheDir
$temporaryCourseRoot = $null

try {
  if (-not $Check) {
    Update-LocksAtRoot -WorkingCourseRoot $CourseRoot
    Write-Host "Course dependency locks updated. Review and commit the intentional changes."
    return
  }

  $temporaryCourseRoot = Join-Path $env:TEMP "atfa-lock-check-$([guid]::NewGuid().ToString('N'))"
  Copy-CourseLockInputs -Source $CourseRoot -Destination $temporaryCourseRoot
  Update-LocksAtRoot -WorkingCourseRoot $temporaryCourseRoot

  $generatedLocks = @(
    Get-ChildItem -LiteralPath (Join-Path $temporaryCourseRoot "lessons") -Recurse -Force -File -Filter ".terraform.lock.hcl"
  )
  $committedLocks = @(
    Get-ChildItem -LiteralPath (Join-Path $CourseRoot "lessons") -Recurse -Force -File -Filter ".terraform.lock.hcl" |
      Where-Object { $_.FullName -notmatch '[\\/]\.terraform[\\/]' }
  )
  $failures = [System.Collections.Generic.List[string]]::new()

  foreach ($generatedLock in $generatedLocks) {
    $relativePath = [System.IO.Path]::GetRelativePath($temporaryCourseRoot, $generatedLock.FullName)
    $committedPath = Join-Path $CourseRoot $relativePath
    if (-not (Test-Path -LiteralPath $committedPath -PathType Leaf)) {
      $failures.Add("Missing committed lock file: $relativePath")
      continue
    }

    if ((Get-FileHash -LiteralPath $generatedLock.FullName -Algorithm SHA256).Hash -ne
        (Get-FileHash -LiteralPath $committedPath -Algorithm SHA256).Hash) {
      $failures.Add("Lock file is stale: $relativePath")
    }
  }

  foreach ($committedLock in $committedLocks) {
    $relativePath = [System.IO.Path]::GetRelativePath($CourseRoot, $committedLock.FullName)
    $generatedPath = Join-Path $temporaryCourseRoot $relativePath
    if (-not (Test-Path -LiteralPath $generatedPath -PathType Leaf)) {
      $failures.Add("Committed lock has no external dependency in its root: $relativePath")
    }
  }

  if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    throw "Dependency lock check failed with $($failures.Count) issue(s). Run Update-CourseLocks.ps1 and review the changes."
  }

  Write-Host "All $($generatedLocks.Count) course dependency lock files are current."
}
finally {
  if ($temporaryCourseRoot -and (Test-Path -LiteralPath $temporaryCourseRoot)) {
    $resolvedTemp = [System.IO.Path]::GetFullPath($temporaryCourseRoot)
    $resolvedTempParent = [System.IO.Path]::GetFullPath($env:TEMP)
    if (-not $resolvedTemp.StartsWith($resolvedTempParent, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing to remove unexpected temporary path: $resolvedTemp"
    }
    Remove-Item -LiteralPath $resolvedTemp -Recurse -Force
  }

  if ($null -eq $previousPluginCache) {
    Remove-Item Env:TF_PLUGIN_CACHE_DIR -ErrorAction SilentlyContinue
  }
  else {
    $env:TF_PLUGIN_CACHE_DIR = $previousPluginCache
  }
}
