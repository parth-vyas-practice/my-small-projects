provider "azurerm" {
}

resource "random_string" "random" {
  length = 10
  special = false 
  upper = false
}

module "vnet" {
  source = "./vnet"
    location = var.location
    resource_group_name = var.resource_group_name
    fullcidr = var.fullcidr
    subnet1 = var.subnet1
    subnet2 = var.subnet2
    subnet3 = var.subnet3
}
module "vm" {
  source = "./vm"
  location = var.location
  resource_group_name = var.resource_group_name
  subnet-id = module.vnet.subentid1
  env = var.env
  vmsize = var.vmsize
  vm-user-name = var.vm-user-name
}

module "db-server" {
  source = "./db-server"
  location = var.location
  resource_group_name = var.resource_group_name
  db-server-name = random_string.random.result
}
resource "local_file" "dburl" {
  content     = <<-EOT
    ${module.db-server.db-url}
    EOT
    filename = "db-url.txt"
    depends_on = [module.db-server]
}

resource "local_file" "vm-ip" {
    content     = <<-EOT
    ${module.vm.publicip} ansible_user=${var.vm-user-name}
    EOT
    filename = var.inventory
    depends_on = [module.vm]
}

resource "null_resource" "run-ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ${var.inventory} ${var.ansible-playbook-path}"
  }
  depends_on          = [module.vm, local_file.vm-ip]
}