output "network_name" {
  description = "The name of the VPC network."
  value       = module.network.network_name
}

output "subnet_name" {
  description = "The name of the VPC subnet."
  value       = module.network.subnets_names[0]
}

output "db_instance_name" {
  description = "The name of the Cloud SQL PostgreSQL instance."
  value       = module.sql_db.instance_name
}

output "db_instance_connection_name" {
  description = "The connection name of the Cloud SQL instance (used by Cloud SQL Proxy)."
  value       = module.sql_db.instance_connection_name
}

output "db_instance_private_ip" {
  description = "The private IP address of the Cloud SQL instance."
  value       = module.sql_db.private_ip_address
}

output "gcs_bucket_name" {
  description = "The name of the GCS bucket for application data."
  value       = module.gcs_bucket.name
}

output "load_balancer_ip" {
  description = "The external IP address of the HTTP Load Balancer."
  value       = google_compute_global_address.lb_ip.address
}
