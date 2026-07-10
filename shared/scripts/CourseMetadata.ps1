function Get-CourseMetadata {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$CourseRoot
  )

  $courseMapPath = Join-Path $CourseRoot "course-map.yml"
  if (-not (Test-Path -LiteralPath $courseMapPath -PathType Leaf)) {
    throw "Course map not found: $courseMapPath"
  }

  $values = @{}
  $parents = [System.Collections.Generic.List[object]]::new()

  foreach ($line in Get-Content -LiteralPath $courseMapPath) {
    if ($line -match '^\s*(?:#.*)?$' -or $line -match '^\s*-') {
      continue
    }

    if ($line -notmatch '^(?<indent>\s*)(?<key>[A-Za-z0-9_]+):(?:\s*(?<value>.*))?$') {
      continue
    }

    $indent = $Matches.indent.Length
    while ($parents.Count -gt 0 -and $parents[$parents.Count - 1].Indent -ge $indent) {
      $parents.RemoveAt($parents.Count - 1)
    }

    $key = $Matches.key
    $value = $Matches.value.Trim()
    if ([string]::IsNullOrWhiteSpace($value)) {
      $parents.Add([pscustomobject]@{ Indent = $indent; Key = $key })
      continue
    }

    if (($value.StartsWith('"') -and $value.EndsWith('"')) -or
        ($value.StartsWith("'") -and $value.EndsWith("'"))) {
      $value = $value.Substring(1, $value.Length - 2)
    }

    $pathParts = @($parents | ForEach-Object { $_.Key }) + $key
    $values[$pathParts -join '.'] = $value
  }

  return $values
}

function Get-CourseMetadataValue {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [hashtable]$Metadata,

    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  if (-not $Metadata.ContainsKey($Path)) {
    throw "course-map.yml is missing required metadata '$Path'"
  }

  return [string]$Metadata[$Path]
}

function Get-TerraformRootDirectories {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$CourseRoot
  )

  $lessonRoot = Join-Path $CourseRoot "lessons"
  $roots = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

  foreach ($lesson in Get-ChildItem -LiteralPath $lessonRoot -Directory) {
    $lab = Join-Path $lesson.FullName "lab"
    if (Test-Path -LiteralPath $lab -PathType Container) {
      $terraformFiles = @(Get-ChildItem -LiteralPath $lab -File -Filter "*.tf")
      if ($terraformFiles.Count -gt 0) {
        [void]$roots.Add($lab)
      }

      foreach ($versionFile in Get-ChildItem -LiteralPath $lab -Recurse -File -Filter "versions.tf") {
        $candidate = $versionFile.Directory.FullName
        if ($candidate -ne $lab -and $candidate -notmatch '[\\/](?:modules?|examples?)[\\/]') {
          [void]$roots.Add($candidate)
        }
      }
    }
  }

  return @($roots | Sort-Object)
}

function Invoke-CourseNative {
  [CmdletBinding()]
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
