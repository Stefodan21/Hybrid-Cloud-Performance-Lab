resource "azurerm_virtual_network" "vnet" {
  name                = "vnettradingeastus001"
  resource_group_name = coalesce(data.azurerm_resource_group.rg.name, var.resource_group_name)
  location            = var.region
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snatradingeastus001"
  resource_group_name  = coalesce(data.azurerm_resource_group.rg.name, var.resource_group_name)
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  service_endpoint {
    service = "Microsoft.AzureCosmosDB"
  }
}

resource "azurerm_public_ip" "appip" {
  name                = "publiciptradeeastus001"
  location            = var.region
  resource_group_name = coalesce(data.azurerm_resource_group.rg.name, var.resource_group_name)
  allocation_method   = "Dynamic"
  sku                 = "Standard"
  tags                = var.tags
}

