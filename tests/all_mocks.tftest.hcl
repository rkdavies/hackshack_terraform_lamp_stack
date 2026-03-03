mock_provider "aws" {}

mock_data "aws_ami" "ubuntu" {
  defaults = {
    id = "ami-0123456789abcdef0"
  }
}

mock_data "aws_availability_zones" "available" {
  defaults = {
    names = ["us-east-1a", "us-east-1b"]
  }
}

mock_provider "google" {}

mock_data "google_compute_zones" "available" {
  defaults = {
    names = ["us-central1-a", "us-central1-b"]
  }
}

mock_provider "azurerm" {
  features {}
}

mock_data "azurerm_resource_group" "main" {
  defaults = {
    name     = "test-rg"
    location = "eastus"
  }
}
