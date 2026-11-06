resource "google_bigquery_dataset" "this" {
  project = var.project_id

  dataset_id  = var.dataset_id
  location    = var.location
  friendly_name = coalesce(var.friendly_name, var.dataset_id)
  description = var.description

  default_table_expiration_ms = var.default_table_expiration_ms
  delete_contents_on_destroy  = var.delete_contents_on_destroy

  labels = var.labels
}
