# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# Service Bus Outputs
output "service_bus_namespace_name" {
  description = "Name of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.name
}

output "service_bus_namespace_id" {
  description = "ID of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.id
}

output "service_bus_namespace_endpoint" {
  description = "Endpoint of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.endpoint
}

output "service_bus_queue_name" {
  description = "Name of the Service Bus queue"
  value       = azurerm_servicebus_queue.main.name
}

output "service_bus_queue_id" {
  description = "ID of the Service Bus queue"
  value       = azurerm_servicebus_queue.main.id
}

# Service Bus Connection Strings
output "service_bus_send_connection_string" {
  description = "Connection string for sending messages"
  value       = azurerm_servicebus_queue_authorization_rule.send.primary_connection_string
  sensitive   = true
}

output "service_bus_listen_connection_string" {
  description = "Connection string for listening to messages"
  value       = azurerm_servicebus_queue_authorization_rule.listen.primary_connection_string
  sensitive   = true
}

output "service_bus_manage_connection_string" {
  description = "Connection string for managing the queue"
  value       = azurerm_servicebus_queue_authorization_rule.manage.primary_connection_string
  sensitive   = true
}

output "service_bus_namespace_connection_string" {
  description = "Namespace-level connection string"
  value       = azurerm_servicebus_namespace_authorization_rule.main.primary_connection_string
  sensitive   = true
}

# Storage Account Outputs
output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_primary_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

# Container Outputs
output "storage_container_name" {
  description = "Name of the main storage container"
  value       = azurerm_storage_container.main.name
}

output "storage_containers" {
  description = "List of all storage containers"
  value = {
    main      = azurerm_storage_container.main.name
    processed = azurerm_storage_container.processed.name
    failed    = azurerm_storage_container.failed.name
    archive   = azurerm_storage_container.archive.name
  }
}

# SAS Token Output
output "storage_account_sas_token" {
  description = "SAS token for storage account access"
  value       = data.azurerm_storage_account_sas.main.sas
  sensitive   = true
}

# Connection Information
output "connection_info" {
  description = "Connection information for all services"
  value = {
    resource_group          = azurerm_resource_group.main.name
    location               = azurerm_resource_group.main.location
    service_bus_namespace  = azurerm_servicebus_namespace.main.name
    service_bus_queue      = azurerm_servicebus_queue.main.name
    storage_account        = azurerm_storage_account.main.name
    storage_endpoint       = azurerm_storage_account.main.primary_blob_endpoint
    main_container         = azurerm_storage_container.main.name
  }
}

# Configuration Summary
output "configuration_summary" {
  description = "Summary of the deployed configuration"
  value = {
    service_bus = {
      sku                = var.service_bus_sku
      capacity          = var.service_bus_sku == "Premium" ? var.service_bus_capacity : null
      partitioning      = var.enable_partitioning
      max_delivery      = var.max_delivery_count
    }
    queue = {
      max_size_mb       = var.queue_max_size
      ttl_minutes       = var.queue_ttl
      dead_lettering    = var.enable_dead_lettering
      duplicate_detection = var.duplicate_detection
    }
    storage = {
      tier              = var.storage_account_tier
      replication       = var.storage_replication
      access_tier       = var.blob_access_tier
      versioning        = var.enable_versioning
      soft_delete       = var.enable_soft_delete
      retention_days    = var.soft_delete_retention
    }
  }
}
