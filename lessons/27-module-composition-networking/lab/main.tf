module "network_foundation" {
  source = "../../../shared/modules/network-foundation"

  project_prefix = var.project_prefix
  environment    = var.environment
  workload_name  = var.workload_name
  location       = var.location
  address_space  = var.address_space
  subnet_prefixes = {
    web  = "10.80.1.0/24"
    api  = "10.80.2.0/24"
    data = "10.80.3.0/24"
  }
}



