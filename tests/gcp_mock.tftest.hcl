mock_provider "google" {}

mock_data "google_compute_zones" "available" {
  defaults = {
    names = ["us-central1-a", "us-central1-b"]
  }
}
