variable "project_id" {
  description = "The GCP project ID that hosts the bucket."
  type        = string
}

variable "name" {
  description = "The name of the bucket. Must be globally unique."
  type        = string
}

variable "location" {
  description = "The location of the bucket, e.g. asia-northeast1 or ASIA."
  type        = string
  default     = "asia-northeast1"
}

variable "storage_class" {
  description = "The storage class of the bucket."
  type        = string
  default     = "STANDARD"
}

variable "versioning_enabled" {
  description = "Whether object versioning is enabled on the bucket."
  type        = bool
  default     = false
}

variable "lifecycle_delete_age_days" {
  description = "If set, objects older than this many days are deleted by a lifecycle rule. Leave null to disable."
  type        = number
  default     = null
}

variable "labels" {
  description = "Labels to apply to the bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Whether Terraform may delete a non-empty bucket on destroy. Kept false by default on purpose."
  type        = bool
  default     = false
}
