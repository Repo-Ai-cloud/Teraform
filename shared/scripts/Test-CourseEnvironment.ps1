[CmdletBinding()]
param(
  [ValidateSet("Supported", "ExamBaseline", "CurrentStable")]
  [string]$Profile = "Supported",
  [switch]$RequireAzureLogin,
  [string]$CourseRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "CourseMetadata.ps1")

$metadata = Get-CourseMetadata -CourseRoot $CourseRoot
$examBaseline = [version](Get-CourseMetadataValue $metadata "toolchain.terraform.exam_baseline")
$currentStable = [version](Get-CourseMetadataValue $metadata "toolchain.terraform.current_stable")
$latestTestedAzureCli = [version](Get-CourseMetadataValue $metadata "toolchain.azure_cli.latest_tested")
$failures = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

Write-Host "Course environment profile: $Profile"

if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
  $failures.Add("Terraform CLI is not installed or is not on PATH.")
}
else {
  $terraformVersionOutput = & terraform version -json
  if ($LASTEXITCODE -ne 0) {
    $failures.Add("Unable to read the Terraform CLI version.")
  }
  else {
    $terraformVersion = [version](($terraformVersionOutput | Out-String | ConvertFrom-Json).terraform_version)
    Write-Host "Terraform CLI: $terraformVersion"

    switch ($Profile) {
      "ExamBaseline" {
        if ($terraformVersion -ne $examBaseline) {
          $failures.Add("ExamBaseline requires Terraform $examBaseline; found $terraformVersion.")
        }
      }
      "CurrentStable" {
        if ($terraformVersion -ne $currentStable) {
          $failures.Add("CurrentStable requires Terraform $currentStable; found $terraformVersion.")
        }
      }
      default {
        if ($terraformVersion -lt [version]"1.12.0" -or $terraformVersion -ge [version]"2.0.0") {
          $failures.Add("Supported requires Terraform >= 1.12.0 and < 2.0.0; found $terraformVersion.")
        }
      }
    }
  }
}

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
  $message = "Azure CLI is not installed or is not on PATH; Azure labs and provider-registration checks are unavailable."
  if ($RequireAzureLogin) {
    $failures.Add($message)
  }
  else {
    $warnings.Add($message)
  }
}
else {
  $azureVersionOutput = & az version --output json 2>$null
  if ($LASTEXITCODE -ne 0) {
    $failures.Add("Unable to read the Azure CLI version.")
  }
  else {
    $azureVersion = [version](($azureVersionOutput | Out-String | ConvertFrom-Json)."azure-cli")
    Write-Host "Azure CLI: $azureVersion"
    if ($azureVersion -lt $latestTestedAzureCli) {
      $message = "Azure CLI $azureVersion is older than the course's latest-tested version $latestTestedAzureCli."
      if ($RequireAzureLogin) {
        $failures.Add($message)
      }
      else {
        $warnings.Add($message)
      }
    }
    elseif ($azureVersion -gt $latestTestedAzureCli) {
      $warnings.Add("Azure CLI $azureVersion is newer than the course's latest-tested version $latestTestedAzureCli.")
    }
  }

  $accountOutput = & az account show --output json --only-show-errors 2>$null
  $azureLoggedIn = $LASTEXITCODE -eq 0
  if ($azureLoggedIn) {
    $account = $accountOutput | Out-String | ConvertFrom-Json
    Write-Host "Azure login: authenticated subscription '$($account.name)'"

    $requiredNamespaces = @(
      "Microsoft.App",
      "Microsoft.KeyVault",
      "Microsoft.ManagedIdentity",
      "Microsoft.Network",
      "Microsoft.OperationalInsights",
      "Microsoft.Resources",
      "Microsoft.Storage",
      "Microsoft.Web"
    )

    foreach ($namespace in $requiredNamespaces) {
      $registrationState = (& az provider show --namespace $namespace --query registrationState --output tsv --only-show-errors 2>$null | Out-String).Trim()
      if ($LASTEXITCODE -ne 0) {
        $warnings.Add("Could not read registration state for Azure provider namespace $namespace.")
      }
      elseif ($registrationState -ne "Registered") {
        $message = "Azure provider namespace $namespace is '$registrationState'. Register it before running the affected labs."
        if ($RequireAzureLogin) {
          $failures.Add($message)
        }
        else {
          $warnings.Add($message)
        }
      }
      else {
        Write-Host "Azure provider namespace: $namespace (Registered)"
      }
    }
  }
  elseif ($RequireAzureLogin) {
    $failures.Add("No active Azure CLI login. Run 'az login' and select the intended subscription.")
  }
  else {
    $warnings.Add("No active Azure CLI login; provider-registration checks were skipped.")
  }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  $failures.Add("Git is not installed or is not on PATH.")
}
else {
  $gitVersion = (& git --version | Out-String).Trim()
  Write-Host "Git: $gitVersion"
}

Write-Host "PowerShell: $($PSVersionTable.PSVersion)"

foreach ($warning in $warnings) {
  Write-Warning $warning
}

if ($failures.Count -gt 0) {
  foreach ($failure in $failures) {
    Write-Error $failure -ErrorAction Continue
  }
  throw "Course environment check failed with $($failures.Count) issue(s)."
}

Write-Host "Course environment check passed."
