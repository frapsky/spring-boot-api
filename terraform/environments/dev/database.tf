locals {
  read_replica_ip_configuration = {
    ipv4_enabled       = true
    require_ssl        = true
    private_network    = module.network.network_id
    allocated_ip_range = null
  }
}

module "sql_db" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 22.0"

  project_id       = var.project_id
  name             = "${var.db_name}-${var.environment}"
  region           = var.region
  database_version = "POSTGRES_15" # Specify your desired PostgreSQL version
  tier             = var.db_tier

  # High Availability (Regional) - enable for production
  availability_type = var.db_ha_enabled ? "REGIONAL" : "ZONAL"
  zone              = var.db_ha_enabled ? null : var.zone # Zone needed only if not REGIONAL

  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [{ name = "autovacuum", value = "off" }]

  # Network Configuration
  ip_configuration = {
    ipv4_enabled    = true
    private_network = module.network.network_id # Connect via private IP
    require_ssl     = true                      # Enforce SSL connections
  }

  # Backup Configuration (adjust as needed)
  backup_configuration = {
    enabled                        = true
    start_time                     = "03:00" # Example start time (UTC)
    point_in_time_recovery_enabled = true    # Enable Point-in-Time Recovery
  }

  // Read replica configurations
  read_replica_name_suffix = "-test-ha"
  read_replicas = [
    {
      name                  = "0"
      zone                  = var.db_ha_enabled ? null : var.zone
      availability_type     = var.db_ha_enabled ? "REGIONAL" : "ZONAL"
      tier                  = var.db_tier
      ip_configuration      = local.read_replica_ip_configuration
      database_flags        = [{ name = "autovacuum", value = "off" }]
      disk_autoresize       = null
      disk_autoresize_limit = null
      disk_size             = null
      disk_type             = "PD_HDD" # consider using SSD
      user_labels           = { bar = "baz" }
      encryption_key_name   = null
    },
  ]

  # User Configuration
  user_name     = var.db_user_name
  user_password = var.db_user_password

  # Deletion Protection - strongly recommended for production
  deletion_protection = var.environment == "prd" ? true : false

}