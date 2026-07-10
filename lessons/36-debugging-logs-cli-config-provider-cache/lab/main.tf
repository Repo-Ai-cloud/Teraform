locals {
  normalized_prefix = lower(replace(var.project_prefix, " ", "-"))
  environment       = lower(var.environment)
  workload_name     = lower(replace(var.workload_name, " ", "-"))

  common_tags = {
    course              = "certified-terraform-associate-azure-edition"
    managed_by          = "terraform"
    owner               = "platform-learning"
    cost_center         = "training"
    data_classification = "public"
    criticality         = "low"
    lesson              = "36"
    environment         = local.environment
    region              = var.location
    workload            = local.workload_name
  }

}

resource "terraform_data" "lesson_contract" {
  input = {
    lesson_title = "Debugging, Logs, CLI Config, and Provider Cache"
    debug_steps = [
      "Set TF_LOG and TF_LOG_PATH only for focused troubleshooting.",
      "Set plugin_cache_dir in a CLI configuration file for repeated provider installation.",
      "Review and redact logs before sharing them.",
      "Unset logging variables and remove local logs immediately after troubleshooting."
    ]
    safe_demo = "../exercise/Invoke-DebugDemo.ps1 uses only a disposable OS temp directory."
    tags      = local.common_tags
  }
}




