variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "target_instance" {
  description = "Target EC2 instance ID"
  type        = string
}

variable "security_group" {
  description = "ALB security group ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
}
