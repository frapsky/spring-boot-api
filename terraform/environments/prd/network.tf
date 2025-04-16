module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  project_id   = var.project_id
  network_name = "${var.network_name}-${var.environment}"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${var.subnet_name}-${var.environment}"
      subnet_ip             = var.subnet_cidr
      subnet_region         = var.region
      subnet_private_access = "false"
      subnet_flow_logs      = "false"
    }
  ]
}


resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.network_name}-${var.environment}-allow-http-https"
  network = module.network.network_name
  project = var.project_id


  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Allow traffic from the Load Balancer health checks and external IPs
  source_ranges = ["0.0.0.0/0"] # For external access. Restrict if needed.
  # Add Google Cloud health check IP ranges for Load Balancer health checks:
  # 130.211.0.0/22 and 35.191.0.0/16
  # source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "0.0.0.0/0"]

  target_tags = ["webserver"]
}

resource "google_compute_firewall" "allow_ssh" {
  # WARNING: Allowing SSH from 0.0.0.0/0 is a security risk.
  # In real word scenario we would use VPN or jump host/bastion
  name    = "${var.network_name}-${var.environment}-allow-ssh"
  network = module.network.network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # RESTRICT THIS IN PRODUCTION
  target_tags   = ["webserver"]
}