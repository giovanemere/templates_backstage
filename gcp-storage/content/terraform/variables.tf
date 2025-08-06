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

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "${{ values.gcp_project_id }}"
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "${{ values.gcp_region }}"
}

variable "bucket_location" {
  description = "Bucket location"
  type        = string
  default     = "${{ values.bucket_location }}"
}

variable "storage_class" {
  description = "Default storage class"
  type        = string
  default     = "${{ values.storage_class }}"
  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be STANDARD, NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "enable_versioning" {
  description = "Enable object versioning"
  type        = bool
  default     = ${{ values.enable_versioning }}
}

variable "enable_lifecycle" {
  description = "Enable lifecycle management"
  type        = bool
  default     = ${{ values.enable_lifecycle }}
}

variable "lifecycle_age_days" {
  description = "Days after which to move to NEARLINE"
  type        = number
  default     = ${{ values.lifecycle_age_days }}
  validation {
    condition     = var.lifecycle_age_days >= 1 && var.lifecycle_age_days <= 365
    error_message = "Lifecycle age must be between 1 and 365 days."
  }
}
