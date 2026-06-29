## Why

Google Cloud CLI (`gcloud`) is a core DevOps tool for teams working with GCP infrastructure. Currently the devops module has first-class support for kubectl, helm, tfenv, k9s, komiser, and aws, but gcloud must be installed and configured manually. Adding gcloud with the same patterns (aliases, completions, component management) reduces friction and ensures consistent setup across machines.

## What Changes

- Add `gcloud` to `DEVOPS_TOOLS` in `config/base.zsh` so it's installed via the standard devops package pipeline
- Create `pkg/gcloud.zsh` with public functions and convenience aliases for common gcloud workflows (config, auth, compute, container/GKE)
- Create `internal/gcloud.zsh` for completion loading, component installation, and auth helpers
- Register both layers in `pkg/main.zsh` and `internal/main.zsh` respectively
- Create `config/base.zsh` variables for component root and default project/region/zone

## Capabilities

### New Capabilities

- `gcloud-core`: gcloud CLI activation — completions, config, auth, and core component management
- `gcloud-compute`: aliases and helpers for Compute Engine (instances, disks, snapshots)
- `gcloud-container`: aliases and helpers for GKE (clusters, node pools, credentials)

### Modified Capabilities

<!-- No existing capabilities are being modified at the spec level -->

## Impact

- `zsh/modules/devops/config/base.zsh` — new env vars (gcloud component root, default project/region/zone)
- `zsh/modules/devops/internal/main.zsh` — add `source internal/gcloud.zsh`
- `zsh/modules/devops/pkg/main.zsh` — add `source pkg/gcloud.zsh`
- New files: `pkg/gcloud.zsh`, `internal/gcloud.zsh`
