output "dataset_id" {
  description = "The ID of the created dataset."
  value       = google_bigquery_dataset.this.dataset_id
}

output "dataset_self_link" {
  description = "The self link of the created dataset."
  value       = google_bigquery_dataset.this.self_link
}
