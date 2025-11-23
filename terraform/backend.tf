terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "devtfstate12345"
    container_name       = "tfstate"
    key                  = "solar-system.terraform.tfstate"
  }
}
