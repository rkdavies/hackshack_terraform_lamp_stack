variable "instance_type" {
  description = "GCP machine type"
  type        = string
}

variable "network" {
  description = "Network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
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

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
}
