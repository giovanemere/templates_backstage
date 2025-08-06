# Cloud Storage Bucket
resource "google_storage_bucket" "main" {
  name          = local.bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  
  # Force destroy for development environments
  force_destroy = true
  
  # Uniform bucket-level access
  uniform_bucket_level_access = true
  
  # Public access prevention
  public_access_prevention = "enforced"
  
  # Versioning
  dynamic "versioning" {
    for_each = var.enable_versioning ? [1] : []
    content {
      enabled = true
    }
  }
  
  # Lifecycle management
  dynamic "lifecycle_rule" {
    for_each = var.enable_lifecycle ? [1] : []
    content {
      condition {
        age = var.lifecycle_age_days
      }
      action {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
    }
  }
  
  # Additional lifecycle rule for old versions
  dynamic "lifecycle_rule" {
    for_each = var.enable_versioning && var.enable_lifecycle ? [1] : []
    content {
      condition {
        age                   = 90
        with_state           = "ARCHIVED"
      }
      action {
        type = "Delete"
      }
    }
  }
  
  # CORS configuration
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  
  labels = local.common_labels
}

# IAM binding for bucket access
resource "google_storage_bucket_iam_binding" "bucket_admin" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.admin"
  
  members = [
    "serviceAccount:${google_service_account.bucket_sa.email}",
  ]
}

# Service Account for bucket access
resource "google_service_account" "bucket_sa" {
  account_id   = "${var.project_name}-bucket-sa"
  display_name = "${var.project_name} Bucket Service Account"
  description  = "Service account for accessing ${var.project_name} bucket"
}

# Service Account Key
resource "google_service_account_key" "bucket_sa_key" {
  service_account_id = google_service_account.bucket_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
