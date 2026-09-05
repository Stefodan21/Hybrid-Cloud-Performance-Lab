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
