data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
}


resource "azure_virtual_network" "vnet" {
    name = "vnettradingeastus001"
    region = var.region
    address_space = ["10.0.0.0/16"]
}

resource "azure_subnet" "app" {
    name = "snatradingeastus001"
    region = var.region
    address_space = ["10.0.0.0/24"]
}

resource "azure_subnet" "db" {
    name = "sndtradingeastus001"
    region = var.region
    address_space = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "appip" {
    name = "publiciptradeeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
    allocation_method = "Dynamic"
    sku = "Standard"
}


resource "azurerm_lb" "frontendlb" {
    name = "lbtradingeastus001"
    location = var.region
    resource_group_name = var.resource_group_name

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
    instances = 3
    admin_username = var.admin_username

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