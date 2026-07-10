terraform {
  required_version = ">= 1.12.0, < 2.0.0"

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.80"
    }
  }
}


# Backend settings are intentionally empty so each learner can supply
# subscription-specific values during terraform init.
terraform {
  backend "azurerm" {}
}
