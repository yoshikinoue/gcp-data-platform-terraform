terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "data_lake" {
  source = "../../modules/gcs_bucket"

  project_id = var.project_id
  name       = "${var.project_id}-data-lake"
  location   = var.region

  labels = {
    layer = "data-lake"
    env   = "example"
  }
}

module "warehouse" {
  source = "../../modules/bigquery_dataset"

  project_id  = var.project_id
  dataset_id  = "analytics"
  location    = var.region
  description = "Analytics dataset created from examples/minimal."

  labels = {
    layer = "warehouse"
    env   = "example"
  }
}
