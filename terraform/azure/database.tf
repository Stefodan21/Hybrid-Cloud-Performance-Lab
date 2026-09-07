resource "azurerm_storage_account" "tableacct" {
  name                     = "sttabletrading001"
  resource_group_name      = var.resource_group_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"

  tags = var.tags
}

resource "azurerm_storage_table" "table" {
  name               = "tradingmetadata"
  storage_account_id = azurerm_storage_account.tableacct.id
}