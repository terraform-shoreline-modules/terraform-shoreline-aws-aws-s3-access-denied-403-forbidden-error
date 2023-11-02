terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "s3_access_denied_403_forbidden_error" {
  source    = "./modules/s3_access_denied_403_forbidden_error"

  providers = {
    shoreline = shoreline
  }
}