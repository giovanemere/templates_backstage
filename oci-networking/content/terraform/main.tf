terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.oci_tenancy_ocid
  user_ocid        = var.oci_user_ocid
  fingerprint      = var.oci_fingerprint
  private_key_path = var.oci_private_key_path
  region           = var.oci_region
}

# Data sources
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.oci_compartment_ocid
}

# Local values
locals {
  project_name = var.project_name
  common_tags = {
    Project     = var.project_name
    Environment = "development"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}
