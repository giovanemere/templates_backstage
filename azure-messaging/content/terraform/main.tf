terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    storage {
      delete_retention_policy {
        days = var.soft_delete_retention
      }
    }
  }
}

# Random suffix for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Local values
locals {
  project_name = var.project_name
  location     = var.azure_location
  common_tags = {
    Project     = var.project_name
    Environment = "development"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
  
  # Naming convention
  resource_group_name    = "${local.project_name}-rg"
  service_bus_name       = "${local.project_name}-sb-${random_string.suffix.result}"
  queue_name            = "${local.project_name}-queue"
  storage_account_name  = "${replace(local.project_name, "-", "")}st${random_string.suffix.result}"
  container_name        = "${local.project_name}-container"
}
