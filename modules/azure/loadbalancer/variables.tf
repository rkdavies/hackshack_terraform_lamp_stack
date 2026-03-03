variable "backend_pool" {
  description = "Backend network interface ID"
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
