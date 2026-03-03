environment = "prod"

aws_region     = "us-east-1"
gcp_project_id = "lamp-demo-prod"
gcp_region     = "us-central1"

vpc_cidr = {
  aws   = "10.10.0.0/16"
  gcp   = "10.11.0.0/16"
  azure = "10.12.0.0/16"
}

instance_type = {
  aws   = "t3.medium"
  gcp   = "e2-standard-2"
  azure = "Standard_B2s"
}

db_instance_class = {
  aws   = "db.t3.medium"
  gcp   = "db-custom-1-3840"
  azure = "Standard_B2ms"
}

db_name     = "lampdb"
db_username = "admin"

tags = {
  Project     = "LAMP-MultiCloud"
  ManagedBy   = "Terraform"
  Environment = "prod"
}
