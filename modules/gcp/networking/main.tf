resource "google_compute_network" "main" {
  name                    = "gcp-lamp-vpc-${var.environment}"
  auto_create_subnetworks = false
  mtu                     = 1460

  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "private" {
  name          = "gcp-lamp-private"
  ip_cidr_range = var.vpc_cidr
  region        = var.region
  network       = google_compute_network.main.id

  secondary_ip_range {
    range_name    = "gcp-lamp-pod"
    ip_cidr_range = "10.2.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gcp-lamp-service"
    ip_cidr_range = "10.3.0.0/16"
  }

  private_ip_google_access = true
}

resource "google_compute_firewall" "web" {
  name    = "gcp-lamp-web-fw"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lamp-web"]
}

resource "google_compute_router" "main" {
  name    = "gcp-lamp-router"
  network = google_compute_network.main.name
  region  = var.region
}

resource "google_compute_router_nat" "main" {
  name   = "gcp-lamp-nat"
  router = google_compute_router.main.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
