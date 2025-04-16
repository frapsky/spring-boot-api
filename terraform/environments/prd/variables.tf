
variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "europe-central2" # Warsaw, Poland
}

variable "zone" {
  description = "The GCP zone for single-zone resources if needed (often derived from region)."
  type        = string
  default     = "europe-central2-a" # Example zone in Warsaw
}


variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prd')."
  type        = string
}

variable "network_name" {
  description = "The name for the VPC network."
  type        = string
  default     = "app-vpc"
}

variable "subnet_name" {
  description = "The name for the VPC subnet."
  type        = string
  default     = "app-subnet"
}

variable "subnet_cidr" {
  description = "The CIDR block for the VPC subnet."
  type        = string
  default     = "10.10.10.0/24"
}

variable "db_name" {
  description = "The name of the Cloud SQL database instance."
  type        = string
  default     = "app-postgres-db"
}

variable "db_tier" {
  description = "The machine type for the Cloud SQL instance."
  type        = string
}

variable "db_user_name" {
  description = "The default username for the Cloud SQL database."
  type        = string
  default     = "appadmin"
}

variable "db_user_password" {
  description = "The password for the default Cloud SQL database user."
  type        = string
  sensitive   = true
}

variable "db_ha_enabled" {
  description = "Enable High Availability (Regional) for the Cloud SQL instance."
  type        = bool
  # default = false for dev, default = true for prod
}

variable "gcs_bucket_name_suffix" {
  description = "Suffix for the GCS bucket name (will be prepended with project ID and env)."
  type        = string
  default     = "app-data"
}

variable "instance_machine_type" {
  description = "The machine type for the Compute Engine instances."
  type        = string
}

variable "instance_image" {
  description = "The Compute Engine image to use for instances."
  type        = string
  default     = "debian-cloud/debian-11" # Example: Debian 11
}

variable "min_instances" {
  description = "Minimum number of instances in the Managed Instance Group."
  type        = number
  # default = 1 for dev, default = 2 or more for prod
}

variable "max_instances" {
  description = "Maximum number of instances in the Managed Instance Group."
  type        = number
  # default = 2 for dev, default = 10 or more for prod
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization for autoscaling."
  type        = number
  default     = 0.6 # 60%
}
