resource "google_storage_bucket" "this" {
  project  = var.project_id
  name     = var.name
  location = var.location

  storage_class               = var.storage_class
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = var.force_destroy

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_delete_age_days == null ? [] : [var.lifecycle_delete_age_days]

    content {
      action {
        type = "Delete"
      }
      condition {
        age = lifecycle_rule.value
      }
    }
  }

  labels = var.labels
}
