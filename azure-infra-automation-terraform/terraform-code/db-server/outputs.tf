# output "db-url" {
#   value = azurerm_sql_server.dbserver.fully_qualified_domain_name
# }
output "db-url" {
  value       = "Server=tcp:${azurerm_sql_server.dbserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.database.name};Persist Security Info=False;User ID=${azurerm_sql_server.dbserver.administrator_login};Password=${azurerm_sql_server.dbserver.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  depends_on  = [azurerm_sql_server.dbserver, azurerm_sql_database.database]
}
