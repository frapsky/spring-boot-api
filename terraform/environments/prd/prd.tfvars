# Normally I wouldn't push this file into repo, only for task purposes
project_id  = "spring-boot-api-prd"
environment = "prd"
region      = "europe-central2"

# Production-specific settings (larger/HA)
db_tier               = "db-n1-standard-1"
db_ha_enabled         = true
db_user_password      = "changeme_in_a_secure_way_prd" # I would use a secret manager for real passwords
instance_machine_type = "e2-medium"
min_instances         = 2
max_instances         = 10