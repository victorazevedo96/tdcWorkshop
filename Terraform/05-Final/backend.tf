terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateworkshop1009"
    container_name       = "tfstate"
    key                 = "final.tfstate"
  }
}
