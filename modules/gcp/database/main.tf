resource "google_sql_database_instance" "main" {
  name             = "gcp-lamp-mysql"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier              = var.instance_class
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        value = "0.0.0.0/0"
      }
    }

    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "main" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "main" {
  name     = var.db_username
  instance = google_sql_database_instance.main.name
  password = var.db_password
}
