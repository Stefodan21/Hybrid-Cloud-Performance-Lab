data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
}


resource "azure_virtual_network" "vnet" {
    name = "vnettradingeastus001"
    region = var.region

}

resource "azure_subnet" "" {}


resource "azure_virtual_machine"