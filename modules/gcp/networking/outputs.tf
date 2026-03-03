output "network_name" {
  value = google_compute_network.main.name
}

output "network_id" {
  value = google_compute_network.main.id
}

output "subnetwork_name" {
  value = google_compute_subnetwork.private.name
}

output "subnetwork_id" {
  value = google_compute_subnetwork.private.id
}

output "firewall_web_id" {
  value = google_compute_firewall.web.id
}
