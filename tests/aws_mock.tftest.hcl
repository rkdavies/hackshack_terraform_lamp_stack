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
