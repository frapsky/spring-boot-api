terraform {
  backend "gcs" {
    bucket = "spring-boot-api-prd-tf-state"
    prefix = "state/prd"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
