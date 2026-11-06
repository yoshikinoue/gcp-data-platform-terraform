variable "project_id" {
  description = "The GCP project ID that hosts the dataset."
  type        = string
}

variable "dataset_id" {
  description = "The ID of the BigQuery dataset."
  type        = string
}

variable "location" {
  description = "The location of the dataset, e.g. asia-northeast1 or US."
  type        = string
  default     = "asia-northeast1"
}

variable "friendly_name" {
  description = "A human-readable name for the dataset. Defaults to dataset_id when null."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the dataset."
  type        = string
  default     = null
}

variable "default_table_expiration_ms" {
  description = "Default lifetime of tables in the dataset, in milliseconds. Leave null for no expiration."
  type        = number
  default     = null
}

variable "labels" {
  description = "Labels to apply to the dataset."
  type        = map(string)
  default     = {}
}

variable "delete_contents_on_destroy" {
  description = "Whether Terraform deletes all tables in the dataset on destroy. Kept false by default on purpose."
  type        = bool
  default     = false
}
