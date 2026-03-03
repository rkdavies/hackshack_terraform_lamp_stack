output "connection_string" {
  value     = "mysql://${var.db_username}:${var.db_password}@${google_sql_database_instance.main.ip_address[0].ip_address}/${var.db_name}"
  sensitive = true
}

output "instance_id" {
  value = google_sql_database_instance.main.id
}

output "public_ip" {
  value = google_sql_database_instance.main.ip_address[0].ip_address
}
