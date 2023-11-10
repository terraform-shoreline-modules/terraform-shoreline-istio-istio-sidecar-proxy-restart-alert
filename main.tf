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

module "istio_sidecar_proxy_restart_alert" {
  source    = "./modules/istio_sidecar_proxy_restart_alert"

  providers = {
    shoreline = shoreline
  }
}