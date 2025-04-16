module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.2"

  project_id   = var.project_id
  region       = var.region
  name_prefix  = "webserver-${var.environment}-"
  machine_type = var.instance_machine_type
  tags         = ["webserver", "http-server", "https-server", var.environment] # Tags for firewall rules

  network    = module.network.network_name
  subnetwork = module.network.subnets_names[0]

  source_image = var.instance_image
  disk_size_gb = 20
  disk_type    = "pd-balanced" # Or pd-standard / pd-ssd

  startup_script = templatefile("${path.module}/startup-script.tmpl", {
    environment = var.environment
  })

  # service_account = {
  #   email  = "your-service-account@${var.project_id}.iam.gserviceaccount.com"
  #   scopes = ["cloud-platform"] # Adjust scopes as needed
  # }

  # Metadata
  # metadata = {
  #   enable-oslogin = "TRUE"
  # }
}

resource "google_compute_health_check" "http_health_check" {
  name    = "webserver-${var.environment}-http-hc"
  project = var.project_id

  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 13.2"

  project_id        = var.project_id
  region            = var.region
  hostname          = "webserver-${var.environment}-mig"
  instance_template = module.instance_template.self_link
  target_size       = var.min_instances # Initial size, autoscaler will manage it
}