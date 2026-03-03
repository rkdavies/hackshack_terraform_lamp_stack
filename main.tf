module "aws_networking" {
  source = "./modules/aws/networking"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr["aws"]
  tags        = var.tags
}

module "gcp_networking" {
  source = "./modules/gcp/networking"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr["gcp"]
  project_id  = var.gcp_project_id
  region      = var.gcp_region
  tags        = var.tags
}

module "azure_networking" {
  source = "./modules/azure/networking"

  environment  = var.environment
  vpc_cidr     = var.vpc_cidr["azure"]
  location     = var.gcp_region
  tags         = var.tags
}

module "aws_compute" {
  source = "./modules/aws/compute"

  instance_type = var.instance_type["aws"]
  subnet_id      = module.aws_networking.private_subnet_ids[0]
  security_group = module.aws_networking.security_group_id
  ssh_key_path   = var.ssh_key_path
  tags           = var.tags
  depends_on     = [module.aws_networking]
}

module "gcp_compute" {
  source = "./modules/gcp/compute"

  instance_type = var.instance_type["gcp"]
  network       = module.gcp_networking.network_name
  subnetwork    = module.gcp_networking.subnetwork_name
  project_id    = var.gcp_project_id
  region        = var.gcp_region
  zone          = var.gcp_region
  tags          = var.tags
  depends_on    = [module.gcp_networking]
}

module "azure_compute" {
  source = "./modules/azure/compute"

  instance_type       = var.instance_type["azure"]
  subnet_id          = module.azure_networking.subnet_id
  security_group     = module.azure_networking.security_group_id
  ssh_key_path       = var.ssh_key_path
  location           = var.gcp_region
  tags               = var.tags
  resource_group_name = module.azure_networking.resource_group_name
  depends_on         = [module.azure_networking]
}

module "aws_database" {
  source = "./modules/aws/database"

  instance_class   = var.db_instance_class["aws"]
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
  subnet_ids       = module.aws_networking.private_subnet_ids
  security_group_id = module.aws_networking.db_security_group_id
  tags             = var.tags
  depends_on       = [module.aws_networking]
}

module "gcp_database" {
  source = "./modules/gcp/database"

  instance_class = var.db_instance_class["gcp"]
  db_name        = var.db_name
  db_username    = var.db_username
  db_password    = var.db_password
  network        = module.gcp_networking.network_name
  project_id     = var.gcp_project_id
  region         = var.gcp_region
  tags           = var.tags
  depends_on     = [module.gcp_networking]
}

module "azure_database" {
  source = "./modules/azure/database"

  instance_class     = var.db_instance_class["azure"]
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  subnet_id         = module.azure_networking.database_subnet_id
  location          = var.gcp_region
  tags              = var.tags
  resource_group_name = module.azure_networking.resource_group_name
  depends_on        = [module.azure_networking]
}

module "aws_loadbalancer" {
  source = "./modules/aws/loadbalancer"

  vpc_id           = module.aws_networking.vpc_id
  subnet_ids       = module.aws_networking.public_subnet_ids
  target_instance  = module.aws_compute.instance_id
  security_group   = module.aws_networking.alb_security_group_id
  tags             = var.tags
  depends_on       = [module.aws_compute]
}

module "gcp_loadbalancer" {
  source = "./modules/gcp/loadbalancer"

  instance_group   = module.gcp_compute.instance_group
  project_id       = var.gcp_project_id
  region           = var.gcp_region
  tags             = var.tags
  depends_on       = [module.gcp_compute]
}

module "azure_loadbalancer" {
  source = "./modules/azure/loadbalancer"

  backend_pool       = module.azure_compute.backend_pool
  location          = var.gcp_region
  tags              = var.tags
  resource_group_name = module.azure_networking.resource_group_name
  depends_on        = [module.azure_compute]
}
