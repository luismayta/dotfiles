## 1. Config layer

- [x] 1.1 Add `DEVOPS_GCLOUD_CONFIG_ROOT`, `DEVOPS_GCLOUD_PACKAGE_NAME` and optional `CLOUDSDK_*` vars to `config/base.zsh`
- [x] 1.2 Add `google-cloud-sdk` to `DEVOPS_TOOLS` array in `config/base.zsh`

## 2. Internal implementation

- [x] 2.1 Create `internal/gcloud.zsh` with completion loading for `gcloud`, `gsutil`, and `bq`
- [x] 2.2 Add auth helper functions (`devops::gcloud::auth::login`, `devops::gcloud::auth::application_default`)
- [x] 2.3 Add component management function (`devops::gcloud::components::install`) for `gke-gcloud-auth-plugin`
- [x] 2.4 Wire `internal/gcloud.zsh` into `internal/main.zsh` after existing tool layers

## 3. Public package

- [x] 3.1 Create `pkg/gcloud.zsh` with config aliases (`gconf`, `gprojects`)
- [x] 3.2 Add compute aliases (`gce_instances`, `gce_ssh`, `gce_describe`, `gce_disks`, `gce_disk_describe`, `gce_snapshots`, `gce_snapshot_create`)
- [x] 3.3 Add container/GKE aliases (`gke_clusters`, `gke_node_pools`, `gke_node_pool_describe`) and `devops::gcloud::gke::get-credentials` function
- [x] 3.4 Wire `pkg/gcloud.zsh` into `pkg/main.zsh` after `pkg/aws.zsh`
