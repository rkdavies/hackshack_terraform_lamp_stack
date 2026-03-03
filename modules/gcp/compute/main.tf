resource "google_compute_instance" "web" {
  name         = "gcp-lamp-web"
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20230601"
      size  = 20
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
    }
  }

  tags = ["lamp-web"]

  metadata = {
    hostname = "www.hackshack.sh"
    startup-script = <<-EOF
      #!/bin/bash
      hostnamectl set-hostname www.hackshack.sh
      apt-get update
      apt-get install -y git apache2 libapache2-mod-wsgi-py3 python3-pip
      pip3 install django mysqlclient
      
      mkdir -p /var/www/html
      git clone git@github.com:rkdavies/hackshack_web.git /var/www/html/hackshack_web
      
      cat > /etc/apache2/sites-available/hackshack.conf << APACHECONF
      <VirtualHost *:80>
          ServerName www.hackshack.sh
          DocumentRoot /var/www/html/hackshack_web
          
          <Directory /var/www/html/hackshack_web>
              Options Indexes FollowSymLinks
              AllowOverride All
              Require all granted
          </Directory>
          
          WSGIScriptAlias / /var/www/html/hackshack_web/hackshack/wsgi.py
          WSGIPythonPath /var/www/html/hackshack_web
          
          <Directory /var/www/html/hackshack_web/hackshack>
              <Files wsgi.py>
                  Require all granted
              </Files>
          </Directory>
      </VirtualHost>
      APACHECONF
      
      a2ensite hackshack.conf
      a2dissite 000-default.conf
      systemctl enable apache2
      systemctl restart apache2
      EOF
  }

  labels = var.tags
}

resource "google_compute_instance_group" "web" {
  name        = "gcp-lamp-web-ig"
  zone        = var.zone
  instances   = [google_compute_instance.web.id]
  named_port {
    name = "http"
    port = 80
  }
}
