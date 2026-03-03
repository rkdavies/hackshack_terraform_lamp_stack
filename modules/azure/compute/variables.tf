variable "instance_type" {
  description = "Azure VM size"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group" {
  description = "Network security group ID"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to SSH public key"
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

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  default     = ""
}

variable "cloudflare_domain" {
  description = "Domain name for DNS"
  type        = string
  default     = "hackshack.sh"
}
