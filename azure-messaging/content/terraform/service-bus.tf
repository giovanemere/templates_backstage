# Service Bus Namespace
resource "azurerm_servicebus_namespace" "main" {
  name                = local.service_bus_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.service_bus_sku
  capacity            = var.service_bus_sku == "Premium" ? var.service_bus_capacity : null

  tags = local.common_tags
}

# Service Bus Queue
resource "azurerm_servicebus_queue" "main" {
  name         = local.queue_name
  namespace_id = azurerm_servicebus_namespace.main.id

  # Queue configuration
  enable_partitioning                   = var.enable_partitioning
  max_delivery_count                   = var.max_delivery_count
  max_size_in_megabytes               = var.queue_max_size
  default_message_ttl                 = "PT${var.queue_ttl}M"
  dead_lettering_on_message_expiration = var.enable_dead_lettering
  requires_duplicate_detection         = var.duplicate_detection
  
  # Additional settings
  auto_delete_on_idle                 = "P10675199DT2H48M5.4775807S" # Max value
  enable_express                      = var.service_bus_sku != "Premium" ? false : null
  enable_batched_operations          = true
  requires_session                   = false
  
  # Duplicate detection window (only if duplicate detection is enabled)
  duplicate_detection_history_time_window = var.duplicate_detection ? "PT10M" : null
}

# Service Bus Queue Authorization Rule for Send
resource "azurerm_servicebus_queue_authorization_rule" "send" {
  name     = "${local.queue_name}-send"
  queue_id = azurerm_servicebus_queue.main.id

  listen = false
  send   = true
  manage = false
}

# Service Bus Queue Authorization Rule for Listen
resource "azurerm_servicebus_queue_authorization_rule" "listen" {
  name     = "${local.queue_name}-listen"
  queue_id = azurerm_servicebus_queue.main.id

  listen = true
  send   = false
  manage = false
}

# Service Bus Queue Authorization Rule for Manage
resource "azurerm_servicebus_queue_authorization_rule" "manage" {
  name     = "${local.queue_name}-manage"
  queue_id = azurerm_servicebus_queue.main.id

  listen = true
  send   = true
  manage = true
}

# Service Bus Namespace Authorization Rule (for namespace-level access)
resource "azurerm_servicebus_namespace_authorization_rule" "main" {
  name         = "${local.service_bus_name}-manage"
  namespace_id = azurerm_servicebus_namespace.main.id

  listen = true
  send   = true
  manage = true
}
