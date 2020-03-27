output "publicip" {
  value = module.vm.publicip
  depends_on = [module.vm]
}

// output "db-url" {
//   value = module.db-server.db-url
//   depends_on = [module.db-server]
// }
