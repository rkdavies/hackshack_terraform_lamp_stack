variable "instance_class" {
  description = "Azure SQL Database tier"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database admin username"
  type        = string
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}
