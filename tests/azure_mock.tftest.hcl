mock_provider "azurerm" {
  features {}
}

mock_data "azurerm_resource_group" "main" {
  defaults = {
    name     = "test-rg"
    location = "eastus"
  }
}
