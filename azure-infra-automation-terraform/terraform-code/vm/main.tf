# Create public IPs
resource "azurerm_public_ip" "publicip-1" {
    name                         = "PublicIP-${var.env}"
    location                     = var.location
    resource_group_name          = var.resource_group_name
    allocation_method            = "Static"

    tags = {
        environment = var.env
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "networkSG" {
    name                = "NetworkSecurityGroup-${var.env}"
    location            = var.location
    resource_group_name = var.resource_group_name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Trafic"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "SecureTrafic"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags = {
        environment = var.env
    }
}

# Create network interface
resource "azurerm_network_interface" "nic-1" {
  name                = "nic-1-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_security_group_id = azurerm_network_security_group.networkSG.id

  ip_configuration {
    name                          = "ipconfig1-${var.env}"
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip-1.id
  }
  tags = {
        environment = var.env
    }
}

# create vm
resource "azurerm_virtual_machine" "vm1" {
  name                  = "vm1-${var.env}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic-1.id]
  vm_size               = var.vmsize

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.vm-user-name
    admin_password = "Password1234"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        path     = "/home/azureuser/.ssh/authorized_keys"
        key_data = file("~/.ssh/id_rsa.pub")
    }
  }
  tags = {
    environment = var.env
  }
}

