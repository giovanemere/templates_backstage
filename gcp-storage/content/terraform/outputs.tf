# Bucket Outputs
output "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.main.name
}

output "bucket_url" {
  description = "URL of the Cloud Storage bucket"
  value       = google_storage_bucket.main.url
}

output "bucket_self_link" {
  description = "Self link of the Cloud Storage bucket"
  value       = google_storage_bucket.main.self_link
}

output "bucket_location" {
  description = "Location of the Cloud Storage bucket"
  value       = google_storage_bucket.main.location
}

output "bucket_storage_class" {
  description = "Storage class of the Cloud Storage bucket"
  value       = google_storage_bucket.main.storage_class
}

# Service Account Outputs
output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.bucket_sa.email
}

output "service_account_key" {
  description = "Service account key (base64 encoded)"
  value       = google_service_account_key.bucket_sa_key.private_key
  sensitive   = true
}

# Connection Information
output "connection_info" {
  description = "Connection information for the bucket"
  value = {
    project_id          = var.gcp_project_id
    bucket_name         = google_storage_bucket.main.name
    bucket_url          = google_storage_bucket.main.url
    service_account     = google_service_account.bucket_sa.email
    region             = var.gcp_region
  }
}

# Configuration Summary
output "configuration_summary" {
  description = "Summary of the deployed configuration"
  value = {
    bucket = {
      name           = google_storage_bucket.main.name
      location       = var.bucket_location
      storage_class  = var.storage_class
      versioning     = var.enable_versioning
      lifecycle      = var.enable_lifecycle
    }
  }
}
