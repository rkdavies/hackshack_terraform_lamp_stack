output "aws_lb_dns" {
  description = "AWS Load Balancer DNS name"
  value       = module.aws_loadbalancer.dns_name
}

output "gcp_lb_ip" {
  description = "GCP Load Balancer IP address"
  value       = module.gcp_loadbalancer.ip_address
}

output "azure_lb_ip" {
  description = "Azure Load Balancer IP address"
  value       = module.azure_loadbalancer.ip_address
}

output "aws_instance_ip" {
  description = "AWS Instance private IP"
  value       = module.aws_compute.private_ip
}

output "gcp_instance_ip" {
  description = "GCP Instance IP"
  value       = module.gcp_compute.ip_address
}

output "azure_instance_ip" {
  description = "Azure Instance IP"
  value       = module.azure_compute.ip_address
}

output "aws_db_endpoint" {
  description = "AWS Database endpoint"
  value       = module.aws_database.endpoint
  sensitive   = true
}

output "gcp_db_endpoint" {
  description = "GCP Database connection string"
  value       = module.gcp_database.connection_string
  sensitive   = true
}

output "azure_db_endpoint" {
  description = "Azure Database connection string"
  value       = module.azure_database.connection_string
  sensitive   = true
}
