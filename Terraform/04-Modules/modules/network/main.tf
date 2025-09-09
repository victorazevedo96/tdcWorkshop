resource "azurerm_virtual_network" "this" {
  name                = "${local.prefix}-vnet"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.rg_name
  tags                = local.common_tags
}

resource "azurerm_subnet" "this" {
  name                 = "${local.prefix}-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
address_prefixes     = [cidrsubnet(var.address_space, 8, 0)]
}

resource "azurerm_network_security_group" "this" {
  name                = "${local.prefix}-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}