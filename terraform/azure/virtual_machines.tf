locals {
  app_vm_names = [
    "lvmstradingeastus001",
    "lvmstradingeastus002",
    "lvmstradingeastus003",
  ]
}

resource "azurerm_network_interface" "app" {
  count               = 3
  name                = "nicvmsstradingeastus00${count.index + 1}"
  location            = var.region
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfigvmsstradingeastus00${count.index + 1}"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  count               = 3
  name                = local.app_vm_names[count.index]
  resource_group_name = var.resource_group_name
  location            = var.region
  size                = "Standard_A2_v2"
  admin_username      = var.admin_username
  tags                = var.tags
  network_interface_ids = [
    azurerm_network_interface.app[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm_key.public_key_openssh
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "9-LVM"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "app" {
  count                   = 3
  network_interface_id    = azurerm_network_interface.app[count.index].id
  ip_configuration_name   = "ipconfigvmsstradingeastus00${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.appbackendpool.id
}

resource "azurerm_virtual_machine_extension" "app" {
  count                      = 3
  name                       = "vmssextension00${count.index + 1}"
  virtual_machine_id         = azurerm_linux_virtual_machine.app[count.index].id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "fileUris": [
        "https://raw.githubusercontent.com/Stefodan21/fedora-bootstrap-suite/main/bootstrap.sh",
        "https://raw.githubusercontent.com/Stefodan21/fedora-bootstrap-suite/main/packagebootstrap.sh",
        "https://raw.githubusercontent.com/Stefodan21/fedora-bootstrap-suite/main/networkbootstrap.sh",
        "https://raw.githubusercontent.com/Stefodan21/fedora-bootstrap-suite/main/databasebootstrap.sh",
        "https://raw.githubusercontent.com/Stefodan21/fedora-bootstrap-suite/main/securitybootstrap.sh"
      ],
      "commandToExecute": "bash bootstrap.sh"
    }
  SETTINGS
}