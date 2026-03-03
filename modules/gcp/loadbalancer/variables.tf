variable "instance_group" {
  description = "Instance group ID"
  type        = string
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
}
