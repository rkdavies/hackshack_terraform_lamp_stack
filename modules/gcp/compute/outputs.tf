output "instance_id" {
  value = google_compute_instance.web.id
}

output "ip_address" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

output "instance_group" {
  value = google_compute_instance_group.web.id
}
