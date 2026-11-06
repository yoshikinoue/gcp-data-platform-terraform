# gcp-data-platform-terraform

Minimal Terraform modules for a Google Cloud data platform: a Cloud Storage
bucket for the data lake layer and a BigQuery dataset for the warehouse layer.
Small on purpose — each module does one thing, exposes a few variables, and
sets safe defaults (uniform bucket-level access, public access prevention,
no force-destroy).

Google Cloud 上のデータ基盤の最小構成を Terraform モジュール化したものです。
データレイク層の GCS バケットと、ウェアハウス層の BigQuery データセットを、
安全側のデフォルト付きで提供します。

## Modules

| Module | Purpose |
|---|---|
| `modules/gcs_bucket` | Cloud Storage bucket with uniform bucket-level access, public access prevention enforced, optional versioning and lifecycle rule |
| `modules/bigquery_dataset` | BigQuery dataset with labels and optional default table expiration |

## Usage

See `examples/minimal` for a root module that wires both together:

```hcl
module "data_lake" {
  source = "../../modules/gcs_bucket"

  project_id = var.project_id
  name       = "${var.project_id}-data-lake"
  location   = var.region
}

module "warehouse" {
  source = "../../modules/bigquery_dataset"

  project_id = var.project_id
  dataset_id = "analytics"
  location   = var.region
}
```

## Requirements

- Terraform >= 1.5
- Google provider >= 5.0
- A GCP project with the `storage.googleapis.com` and
  `bigquery.googleapis.com` APIs enabled

## Design notes

- Defaults are safe, not convenient: `force_destroy` and
  `delete_contents_on_destroy` stay `false` unless you opt in.
- Region is a variable everywhere. Examples use `asia-northeast1`.
- Labels are merged, never overwritten silently, so cost allocation by
  team/environment keeps working when modules are composed.

## Roadmap

- BigQuery table module with schema and partitioning examples
- IAM bindings module (least-privilege roles for data engineers / analysts)
- Dataform workspace example

## License

MIT
