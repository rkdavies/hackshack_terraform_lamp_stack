variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for instance"
  type        = string
}

variable "security_group" {
  description = "Security group ID"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
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
