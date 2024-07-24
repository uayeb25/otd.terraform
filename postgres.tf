resource "azurerm_private_dns_zone" "postgres_private_dns_zone" {
    name                = "privatelink.postgres.database.azure.com"
    resource_group_name = azurerm_resource_group.rg.name

    tags = var.tags
}

resource "azurerm_postgresql_flexible_server" "postgres" {
    name                   = "${var.project}-postgres-${var.environment}"
    location               = var.location
    resource_group_name    = azurerm_resource_group.rg.name
    administrator_login    = var.postgres_admin_username
    administrator_password = var.postgres_admin_password
    version                = "12"
    sku_name               = "B_Standard_B1ms"
    storage_mb             = 32768
    backup_retention_days  = 7
    geo_redundant_backup_enabled  = false

    delegated_subnet_id    = azurerm_subnet.subnetpostgre.id
    private_dns_zone_id    = azurerm_private_dns_zone.postgres_private_dns_zone.id

    public_network_access_enabled = false

    tags = var.tags

    depends_on = [
        azurerm_virtual_network.vnet
        , azurerm_private_dns_zone.postgres_private_dns_zone
    ]
}

resource "azurerm_private_endpoint" "postgres_private_endpoint" {
    name                = "${var.project}-2-postgres-private-endpoint-${var.environment}"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    subnet_id           = azurerm_subnet.subnetpostgre.id

    private_service_connection {
        name                           = "postgres-private-connection"
        private_connection_resource_id = azurerm_postgresql_flexible_server.postgres.id
        subresource_names              = ["postgresqlServer"]
        is_manual_connection           = false
    }

    tags = var.tags

    depends_on = [
        azurerm_postgresql_flexible_server.postgres
    ]
}