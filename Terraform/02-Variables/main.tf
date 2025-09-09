resource "azurerm_resource_group" "main" {
  name     = "${local.name}"
  location = var.location
  tags     = local.common_tags
}