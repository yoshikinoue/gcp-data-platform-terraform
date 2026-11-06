variable "project_id" {
  description = "The GCP project ID to create the resources in."
  type        = string
}

variable "region" {
  description = "The region/location for the bucket and the dataset."
  type        = string
  default     = "asia-northeast1"
}
