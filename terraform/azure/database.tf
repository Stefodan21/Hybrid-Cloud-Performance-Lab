resource "azurerm_cosmosdb_account" "cdbaccount" {
    name = "cosmosdbtradingeastus001"
    location = var.region
    resource_group_name = var.resource_group_name
    offer_type = "standard"

    public_network_access_enabled = false

    virtual_network_rule {
        id = azurerm_subnet.app.id
    }

    geo_location {
        location          = "eastus"
        failover_priority = 0
    }

    geo_location {
        location          = "westus"
        failover_priority = 1
    }

    consistency_policy {
        consistency_level = "Session"
    }

    tags = var.tags

}

resource "azurerm_cosmosdb_table" "cdtable" {
    name = "cdtabletradingeastus001"
    resource_group_name = var.resource_group_name
    account_name = azurerm_cosmosdb_account.cdbaccount.name
    throughput = var.throughput
}