output "vnetname" {
  value = azurerm_virtual_network.vnet1.name
}
output "subentid1" {
  value = azurerm_virtual_network.vnet1.subnet.*.id[0]
}
output "subentid2" {
  value = azurerm_virtual_network.vnet1.subnet.*.id[1]
}
output "subentid3" {
  value = azurerm_virtual_network.vnet1.subnet.*.id[2]
}
