data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    
}


resource "azure_virtual_network" "vnet" {
    name = "vnettradingeastus001"
    region = var.region
    address_space = ["10.0.0.0/16"]
    tags = var.tags
}

resource "azure_subnet" "app" {
    name = "snatradingeastus001"
    region = var.region
    address_space = ["10.0.0.0/24"]
    tags = var.tags
}

resource "azure_subnet" "db" {
    name = "sndtradingeastus001"
    region = var.region
    address_space = ["10.0.1.0/24"]
    tags = var.tags
}


resource "azurerm_public_ip" "appip" {
    name = "publiciptradeeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
    allocation_method = "Dynamic"
    sku = "Standard"
    tags = var.tags
}


resource "azurerm_lb" "frontendlb" {
    name = "lbtradingeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
    tags = var.tags

    frontend_ip_configuration {
        name = "feiptradingeastus001"
        public_ip_address_id = azurerm_public_ip.appip.id
    }
}

resource "azurerm_lb_backend_address_pool" "appbackendpool" {
    name = "backendpooltradingeastus001"
    loadbalancer_id = azurerm_lb.frontendlb.id

}

resource "azurerm_linux_virtual_machine_scale_set" "lvmss" {
    name = "lvmsstradingeastus001"
    resource_group_name = var.resource_group_name
    location = var.region
    sku = "Standard_A2_v2"
    instances = 2
    admin_username = var.admin_username

    admin_ssh_key {
        username   = "adminuser"
        public_key = tls_private_key.vm_key.public_key_openssh
    }

    source_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "9-LVM"
        version = "latest"
    }

    network_interface {
        name = "nicvmsstradingeastus001"
        primary = true

        ip_configuration {
            name = "ipconfigvmsstradingeastus001"
            primary = true
            subnet_id = azure_subnet.app.id
            load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.appbackendpool.id]
        }
    }

    os_disk {
        storage_account_type =  "Standard_LRS"
        caching = "ReadWrite"
    }
}

resource "azurerm_monitor_autoscale_setting" "autoscalevmss" {
    name = "autoscalevmss001"
    resource_group_name = var.resource_group_name
    location = var.region
    target_resource_id = azurerm_linux_virtual_machine_scale_set.lvmss.id

  profile {
    name = "autoscaleprofile001"

    capacity {
        minimum = 2
        maximum = 4
        default = 2
    }

    rule {
        metric_trigger {
            metric_name = "Percentage CPU"
            metric_resource_id = azurerm_linux_virtual_machine_scale_set.lvmss.id
            operator = "GreaterThan"
            threshold = 70
            time_aggregation = "Average"
            time_grain = "PT1M"
            statistic = "Average"
            time_window = "PT5M"
        }
        scale_action {
            direction = "Increase"
            type = "ChangeCount"
            value = 1
            cooldown = "PT5M"

        }
    }

    rule {
        metric_trigger {
            metric_name = "Percentage CPU"
            metric_resource_id = azurerm_linux_virtual_machine_scale_set.lvmss.id
            operator = "LessThan"
            threshold = 5
            time_aggregation = "Average"
            time_grain = "PT1M"
            statistic = "Average"
            time_window = "PT5M"

        }
        
        scale_action {
            direction = "Decrease"
            type = "ChangeCount"
            value = 1
            cooldown = "PT5M"
        }

    }
  }
}
# resource "azurerm_network_interface" "appnic" {
#     name = "nicvmtradingeastus001"
#     location = var.region
#     resource_group_name = var.resource_group_name
#     tags = var.tags

#     ip_configuration {
#         name = "ipconfigvmtradingeastus001"
#         subnet_id = azure_subnet.app.id
#         private_ip_address_allocation = "Static"
#         private_ip_address = "10.0.0.4"

#     }
# }
# resource "azurerm_linux_virtual_machine" "lvm" {
#     name = "vmtradingeastus001"
#     resource_group_name = var.resource_group_name
#     location = var.region
#     size = "Standard_A2_v2"
#     admin_username = var.admin_username

#     admin_ssh_key {
#         username   = "adminuser"
#         public_key = tls_private_key.vm_key.public_key_openssh
#     }
#     tags = var.tags



#     source_image_reference {
#         publisher = "RedHat"
#         offer = "RHEL"
#         sku = "9-lvm"
#         version = "latest"

#     }

#     os_disk {
#         name = "osdiskvmtradingeastus001"
#         storage_account_type = "Standard_LRS"
#         caching = "ReadWrite"
#     }

#     network_interface_ids = [azurerm_network_interface.appnic.id]


# }

resource "tls_private_key" "vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "azurerm_network_security_group" "appnsg" {
    name = "nsgtradingeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
    tags = var.tags
    security_rule {
        name = "AllowSSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "10.0.0.4"
    }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azure_subnet.app.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}