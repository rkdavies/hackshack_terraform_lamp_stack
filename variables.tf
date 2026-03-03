variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
  default     = "lamp-demo-project"
}

variable "gcp_region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "1111111111111"
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = "1111111111111"
}

variable "azure_client_id" {
  description = "Azure client ID"
  type        = string
  default     = "1111111111111"
}

variable "azure_client_secret" {
  description = "Azure client secret"
  type        = string
  default     = "111111111111"
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPCs"
  type        = map(string)
  default = {
    aws   = "10.0.0.0/16"
    gcp   = "10.1.0.0/16"
    azure = "10.2.0.0/16"
  }
}

variable "instance_type" {
  description = "Instance type for compute resources"
  type        = map(string)
  default = {
    aws   = "t3.small"
    gcp   = "e2-medium"
    azure = "Standard_B1s"
  }
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = map(string)
  default = {
    aws   = "db.t3.micro"
    gcp   = "db-f1-micro"
    azure = "Basic_B1ms"
  }
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "lampdb"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
  default     = "password!not!for#use$"
}

variable "ssh_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_cidr" {
  description = "CIDR blocks allowed to access resources"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "LAMP-MultiCloud"
    ManagedBy   = "Terraform"
    Environment = "dev"
  }
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  default     = ""
}

variable "cloudflare_domain" {
  description = "Domain name for DNS records (e.g., hackshack.sh)"
  type        = string
  default     = "hackshack.sh"
}
