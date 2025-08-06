# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication
  access_tier              = var.blob_access_tier

  # Security settings
  enable_https_traffic_only       = true
  min_tls_version                = "TLS1_2"
  allow_nested_items_to_be_public = false

  # Network rules
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
  }

  # Blob properties
  blob_properties {
    # Versioning
    versioning_enabled = var.enable_versioning
    
    # Change feed
    change_feed_enabled = true
    
    # Last access time tracking
    last_access_time_enabled = true

    # Soft delete for blobs
    dynamic "delete_retention_policy" {
      for_each = var.enable_soft_delete ? [1] : []
      content {
        days = var.soft_delete_retention
      }
    }

    # Soft delete for containers
    dynamic "container_delete_retention_policy" {
      for_each = var.enable_soft_delete ? [1] : []
      content {
        days = var.soft_delete_retention
      }
    }
  }

  tags = local.common_tags
}

# Storage Container
resource "azurerm_storage_container" "main" {
  name                  = local.container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Additional containers for different purposes
resource "azurerm_storage_container" "processed" {
  name                  = "${local.container_name}-processed"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "failed" {
  name                  = "${local.container_name}-failed"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "archive" {
  name                  = "${local.container_name}-archive"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Storage Account SAS Token (for programmatic access)
data "azurerm_storage_account_sas" "main" {
  connection_string = azurerm_storage_account.main.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "8760h") # 1 year

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    tag     = true
    filter  = true
  }
}

# Management Policy for lifecycle management
resource "azurerm_storage_management_policy" "main" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "lifecycle-rule"
    enabled = true

    filters {
      prefix_match = ["${local.container_name}/"]
      blob_types   = ["blockBlob"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
      
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
      
      version {
        delete_after_days_since_creation = 90
      }
    }
  }
}
