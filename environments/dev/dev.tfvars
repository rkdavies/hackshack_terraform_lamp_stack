environment = "dev"

aws_region     = "us-east-1"
gcp_project_id = "lamp-demo-dev"
gcp_region     = "us-central1"

vpc_cidr = {
  aws   = "10.0.0.0/16"
  gcp   = "10.1.0.0/16"
  azure = "10.2.0.0/16"
}

instance_type = {
  aws   = "t3.small"
  gcp   = "e2-medium"
  azure = "Standard_B1s"
}

db_instance_class = {
  aws   = "db.t3.micro"
  gcp   = "db-f1-micro"
  azure = "Basic_B1ms"
}

db_name     = "lampdb"
db_username = "admin"

tags = {
  Project     = "LAMP-MultiCloud"
  ManagedBy   = "Terraform"
  Environment = "dev"
}
