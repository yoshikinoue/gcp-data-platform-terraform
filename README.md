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

### Module reference

#### `modules/gcs_bucket`

Inputs:

| Name | Type | Default | Required |
|---|---|---|---|
| `project_id` | string | — | yes |
| `name` | string | — | yes |
| `location` | string | `"asia-northeast1"` | no |
| `storage_class` | string | `"STANDARD"` | no |
| `versioning_enabled` | bool | `false` | no |
| `lifecycle_delete_age_days` | number | `null` (rule disabled) | no |
| `labels` | map(string) | `{}` | no |
| `force_destroy` | bool | `false` | no |

Outputs: `bucket_name`, `bucket_url`

#### `modules/bigquery_dataset`

Inputs:

| Name | Type | Default | Required |
|---|---|---|---|
| `project_id` | string | — | yes |
| `dataset_id` | string | — | yes |
| `location` | string | `"asia-northeast1"` | no |
| `friendly_name` | string | `null` (defaults to `dataset_id`) | no |
| `description` | string | `null` | no |
| `default_table_expiration_ms` | number | `null` (no expiration) | no |
| `labels` | map(string) | `{}` | no |
| `delete_contents_on_destroy` | bool | `false` | no |

Outputs: `dataset_id`, `dataset_self_link`

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

## Getting started

```bash
cd examples/minimal
terraform init
terraform plan -var project_id=YOUR_PROJECT_ID
terraform apply -var project_id=YOUR_PROJECT_ID
```

Requires the APIs listed under Requirements, and Google Cloud credentials
available to Terraform (for example via
`gcloud auth application-default login`). The example region defaults to
`asia-northeast1`; override with `-var region=...`.

## Requirements

- Terraform >= 1.5
- Google provider >= 5.0
- A GCP project with the `storage.googleapis.com` and
  `bigquery.googleapis.com` APIs enabled

## Why these defaults

- `uniform_bucket_level_access = true` and `public_access_prevention =
  "enforced"` are hard-coded, not variables. A data lake bucket should never
  fall back to per-object ACLs or become publicly reachable because a flag
  was forgotten.
- `force_destroy` and `delete_contents_on_destroy` default to `false` and
  are explicit opt-ins. Destroying Terraform state must never silently
  delete data.
- Versioning is off by default. Lake data is normally reproducible from
  upstream sources; enable versioning when the bucket holds the only copy.
- Lifecycle deletion is opt-in (`lifecycle_delete_age_days`). Retention is
  a data governance decision, not a module default. The same applies to
  `default_table_expiration_ms` on the dataset: expiry belongs to the data
  owner.
- Region is a variable everywhere. Examples default to `asia-northeast1`.

## How this maps to a real platform

The two modules are the storage foundation only: a lake layer for raw,
append-only landing data, and a warehouse layer for modeled datasets.
Tables, IAM, and orchestration are deliberately separate concerns (see
Roadmap), so each layer can change without touching the others.
Labels (`layer`, `env`) are set from the root module and are the seam for
cost allocation and policy enforcement across the platform.

## Roadmap

- BigQuery table module with schema and partitioning examples
- IAM bindings module (least-privilege roles for data engineers / analysts)
- Dataform workspace example

## License

MIT
