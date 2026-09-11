resource "azurerm_linux_virtual_machine_scale_set" "lvmss" {
  name                = "lvmsstradingeastus001"
  resource_group_name = var.resource_group_name
  location            = var.region
  sku                 = "Standard_A2_v2"
  instances           = 2
  admin_username      = var.admin_username
  tags                = var.tags

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

  network_interface {
    name    = "nicvmsstradingeastus001"
    primary = true

    ip_configuration {
      name                                   = "ipconfigvmsstradingeastus001"
      primary                                = true
      subnet_id                              = azurerm_subnet.app.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.appbackendpool.id]
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode = "Manual"
}

resource "azurerm_virtual_machine_scale_set_extension" "vmssextension" {
  name                 = "vmssextension001"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.lvmss.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

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

resource "azurerm_monitor_autoscale_setting" "autoscalevmss" {
  name                = "autoscalevmss001"
  resource_group_name = var.resource_group_name
  location            = var.region
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.lvmss.id
  tags                = var.tags

  profile {
    name = "autoscaleprofile001"

    capacity {
      minimum = 2
      maximum = 4
      default = 2
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.lvmss.id
        operator           = "GreaterThan"
        threshold          = 70
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"

      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.lvmss.id
        operator           = "LessThan"
        threshold          = 5
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"

      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }

    }
  }
}