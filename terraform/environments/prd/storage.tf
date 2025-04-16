module "gcs_bucket" {
  source     = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version    = "~> 10.0"
  project_id = var.project_id
  name       = "${var.project_id}-${var.environment}-${var.gcs_bucket_name_suffix}"
  location   = var.region

}