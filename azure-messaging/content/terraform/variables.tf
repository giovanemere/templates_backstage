variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "${{ values.name }}"
}

variable "owner" {
  description = "Owner of the project"
  type        = string
  default     = "${{ values.owner }}"
}

variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "${{ values.azure_location }}"
}

# Service Bus variables
variable "service_bus_sku" {
  description = "Service Bus SKU"
  type        = string
  default     = "${{ values.service_bus_sku }}"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.service_bus_sku)
    error_message = "Service Bus SKU must be Basic, Standard, or Premium."
  }
}

variable "service_bus_capacity" {
  description = "Service Bus capacity (Premium only)"
  type        = number
  default     = ${{ values.service_bus_capacity }}
  validation {
    condition     = var.service_bus_capacity >= 1 && var.service_bus_capacity <= 16
    error_message = "Service Bus capacity must be between 1 and 16."
  }
}

variable "enable_partitioning" {
  description = "Enable partitioning for the queue"
  type        = bool
  default     = ${{ values.enable_partitioning }}
}

variable "max_delivery_count" {
  description = "Maximum delivery count"
  type        = number
  default     = ${{ values.max_delivery_count }}
  validation {
    condition     = var.max_delivery_count >= 1 && var.max_delivery_count <= 2000
    error_message = "Max delivery count must be between 1 and 2000."
  }
}

# Queue variables
variable "queue_max_size" {
  description = "Maximum size of the queue in MB"
  type        = number
  default     = ${{ values.queue_max_size }}
  validation {
    condition     = contains([1024, 2048, 3072, 4096, 5120], var.queue_max_size)
    error_message = "Queue max size must be 1024, 2048, 3072, 4096, or 5120 MB."
  }
}

variable "queue_ttl" {
  description = "Time to live for messages in minutes"
  type        = number
  default     = ${{ values.queue_ttl }}
  validation {
    condition     = var.queue_ttl >= 1 && var.queue_ttl <= 525600
    error_message = "Queue TTL must be between 1 and 525600 minutes."
  }
}

variable "enable_dead_lettering" {
  description = "Enable dead lettering on message expiration"
  type        = bool
  default     = ${{ values.enable_dead_lettering }}
}

variable "duplicate_detection" {
  description = "Enable duplicate detection"
  type        = bool
  default     = ${{ values.duplicate_detection }}
}

# Storage variables
variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "${{ values.storage_account_tier }}"
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Storage account tier must be Standard or Premium."
  }
}

variable "storage_replication" {
  description = "Storage replication type"
  type        = string
  default     = "${{ values.storage_replication }}"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_replication)
    error_message = "Storage replication must be LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "blob_access_tier" {
  description = "Default access tier for blobs"
  type        = string
  default     = "${{ values.blob_access_tier }}"
  validation {
    condition     = contains(["Hot", "Cool"], var.blob_access_tier)
    error_message = "Blob access tier must be Hot or Cool."
  }
}

variable "enable_versioning" {
  description = "Enable blob versioning"
  type        = bool
  default     = ${{ values.enable_versioning }}
}

variable "enable_soft_delete" {
  description = "Enable soft delete for blobs"
  type        = bool
  default     = ${{ values.enable_soft_delete }}
}

variable "soft_delete_retention" {
  description = "Soft delete retention period in days"
  type        = number
  default     = ${{ values.soft_delete_retention }}
  validation {
    condition     = var.soft_delete_retention >= 1 && var.soft_delete_retention <= 365
    error_message = "Soft delete retention must be between 1 and 365 days."
  }
}
