terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Use an appropriate version
    }
  }

  backend "gcs" {
    bucket = "your-terraform-state-bucket-name" # Needs to be created beforehand
    prefix = "prod/infra"
  }
}