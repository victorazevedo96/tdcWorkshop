resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg"
  location = var.location
}


module "network" {
  source     = "./modules/network"
  project    = var.project
  location   = var.location
  environment = var.environment
  rg_name = azurerm_resource_group.main.name
  address_space = var.address_space
}
