terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
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
  common_labels = {
    project     = var.project_name
    environment = "development"
    managed_by  = "terraform"
    owner       = var.owner
  }
  
  bucket_name = "${local.project_name}-bucket-${random_string.suffix.result}"
}
