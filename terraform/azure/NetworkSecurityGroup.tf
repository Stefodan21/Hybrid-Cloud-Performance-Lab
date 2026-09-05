resource "azurerm_network_security_group" "appnsg" {
    name = "nsgtradingeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
    tags = var.tags
    security_rule {
        name = "AllowSSH"
        priority = 300
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "10.0.0.0/24"
    }
    security_rule {
        name = "AllowHTTPS"
        priority = 400
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "*"
        destination_address_prefix = "10.0.0.0/24"
    }
    security_rule {
        name = "AllowCosmosDB"
        priority = 500
        direction = "Outbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "443"
        destination_port_range = "443"
        source_address_prefix = "10.0.0.0/24"
        destination_address_prefix = "AzureCosmosDB"
    }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azure_subnet.app.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}
