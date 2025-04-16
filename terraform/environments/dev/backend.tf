terraform {
  backend "gcs" {
    bucket = "spring-boot-api-dev-tf-state"
    prefix = "state/dev"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
