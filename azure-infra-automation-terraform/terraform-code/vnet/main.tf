resource "azurerm_network_security_group" "securitygroup1" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_virtual_network" "vnet1" {
  name                = "virtualNetwork1"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.fullcidr]

  subnet {
    name           = "subnet1"
    address_prefix = var.subnet1
  }

  subnet {
    name           = "subnet2"
    address_prefix = var.subnet2
  }

  subnet {
    name           = "subnet3"
    address_prefix = var.subnet3
  }
}
