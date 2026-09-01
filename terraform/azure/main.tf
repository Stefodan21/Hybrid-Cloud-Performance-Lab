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


resource "azurerm_lb" "lb" {
    name = "lbtradingeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
}

resource "azurerm_linux_virtual_machine_scale_set" "lvmss" {
    name = "lvmsstradingeastus001"
}