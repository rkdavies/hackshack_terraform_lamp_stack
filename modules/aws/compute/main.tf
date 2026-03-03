terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group]

  user_data = <<-EOF
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

  key_name = var.ssh_key_path != "" && length(aws_key_pair.ssh) > 0 ? aws_key_pair.ssh[0].key_name : ""

  tags = merge(var.tags, {
    Name = "aws-lamp-web"
  })
}

resource "aws_key_pair" "ssh" {
  count      = var.ssh_key_path != "" ? 1 : 0
  key_name   = "lamp-ssh-key"
  public_key = fileexists(var.ssh_key_path) ? file(var.ssh_key_path) : ""
}

resource "cloudflare_record" "aws" {
  count   = var.cloudflare_zone_id != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = aws_instance.web.public_ip
  type    = "A"
  proxied = true
}
