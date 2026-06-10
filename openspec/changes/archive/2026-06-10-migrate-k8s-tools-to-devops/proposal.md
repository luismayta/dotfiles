## Why

Four external Zsh module repositories (zsh-k9s, zsh-kubectl, zsh-helm, zsh-tfenv) are currently maintained as standalone repos with nearly identical architecture patterns. They all depend on the same `zsh-core` library, share the same OS-dispatch structure (`config/`, `internal/`, `pkg/`), and provide DevOps tooling that logically belongs together. Keeping them separate adds maintenance overhead for dependency synchronization, versioning, and CI. Consolidating them into `zsh/modules/devops/` reduces complexity and aligns with the monorepo strategy.

## What Changes

- **BREAKING**: Migrate `zsh-k9s` → `zsh/modules/devops/` with namespace rename `k9s::*` → `devops::k9s::*`
- **BREAKING**: Migrate `zsh-kubectl` → `zsh/modules/devops/` with namespace rename `kubectl::*` → `devops::kubectl::*`
- **BREAKING**: Migrate `zsh-helm` → `zsh/modules/devops/` with namespace rename `plugin-template::*` → `devops::helm::*`
- **BREAKING**: Migrate `zsh-tfenv` → `zsh/modules/devops/` with namespace rename `tfenv::*` → `devops::tfenv::*`
- Rename env var prefixes accordingly: `K9S_*`, `KUBECTL_*`, `PLUGIN_TEMPLATE_*`, `TFENV_*` → `DEVOPS_*`
- Add auto-install logic for each tool's dependencies (k9s, kubectl + krew plugins, helm, tfenv + terraform versions)
- Register 20+ kubectl aliases as `devops::kubectl::*` aliases
- Port k9s YAML configuration files (`conf/`) to `zsh/modules/devops/conf/k9s/`

## Capabilities

### New Capabilities
- `devops-k9s`: k9s tool installation, configuration syncing, and alias management
- `devops-kubectl`: kubectl + kubecolor installation, krew plugin management, crossplane install, go package management, and 20+ aliases
- `devops-helm`: helm tool installation and basic lifecycle management
- `devops-tfenv`: tfenv installation, terraform version management (install global + all versions), and terragrunt/terraform-docs integration

### Modified Capabilities
- (none — these are all new capabilities within the devops module)

## Impact

- `zsh/modules/devops/` grows from 5 functions to ~40+ functions across config, internal, and pkg layers
- Current `devops::upgrade` stub in `pkg/base.zsh` will need implementation or removal
- External repos will be deprecated in favor of the monorepo module
- k9s YAML config files (`conf/config.yml`, `conf/alias.yml`, `conf/plugin.yml`) need a new home under `zsh/modules/devops/conf/k9s/`
- All existing `plugin-template::*` references in zsh-helm must become `devops::helm::*`
- No changes to `zsh/core/` — these are all module-level additions