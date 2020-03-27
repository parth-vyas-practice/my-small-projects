resource "azurerm_sql_server" "dbserver" {
  name                         = var.db-server-name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "database" {
  name                = "mysqldatabasetest2"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.dbserver.name
  depends_on          = [azurerm_sql_server.dbserver]
}
