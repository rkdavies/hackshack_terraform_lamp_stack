terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  name                = "azure-lamp-web"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.instance_type

  admin_username = "lampadmin"
  admin_ssh_key {
    username   = "lampadmin"
    public_key = var.ssh_key_path != "" && fileexists(var.ssh_key_path) ? file(var.ssh_key_path) : ""
  }

  network_interface_ids = [azurerm_network_interface.web.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
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
  )

  tags = var.tags
}

resource "azurerm_public_ip" "web" {
  name                = "azure-lamp-web-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface" "web" {
  name                = "azure-lamp-web-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "external"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "web" {
  network_interface_id      = azurerm_network_interface.web.id
  network_security_group_id = var.security_group
}

resource "cloudflare_record" "azure" {
  count   = var.cloudflare_zone_id != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = azurerm_public_ip.web.ip_address
  type    = "A"
  proxied = true
}
