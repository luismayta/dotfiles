## 1. Config: Add env vars for all 4 tools

- [x] 1.1 Add `DEVOPS_K9S_PACKAGE_NAME`, `DEVOPS_K9S_CONF_DIR`, `DEVOPS_K9S_FILE_SETTINGS`, `DEVOPS_K9S_MESSAGE_*` to `config/base.zsh`
- [x] 1.2 Add `DEVOPS_KUBECTL_PACKAGE_NAME`, `DEVOPS_KUBECTL_LOCAL_PATH_BIN`, `DEVOPS_KUBECTL_*` vars, `KREW_*`, `DEVOPS_KUBECTL_GO_PACKAGES`, `DEVOPS_KUBECTL_GO_INSTALL` to `config/base.zsh`
- [x] 1.3 Add `DEVOPS_HELM_PACKAGE_NAME`, `DEVOPS_HELM_MESSAGE_*` vars to `config/base.zsh`
- [x] 1.4 Add `DEVOPS_TFENV_ROOT`, `DEVOPS_TFENV_ROOT_BIN`, `DEVOPS_TFENV_PACKAGE_NAME`, `DEVOPS_TFENV_VERSIONS`, `DEVOPS_TFENV_VERSION_GLOBAL`, `DEVOPS_TFENV_MESSAGE_*`, `TF_PLUGIN_CACHE_DIR` to `config/base.zsh`
- [x] 1.5 Set `DEVOPS_TOOLS` to include k9s, kubectl, helm, tfenv, terragrunt, terraform-docs

## 2. Internal: Create k9s internal functions

- [x] 2.1 Create `internal/k9s.zsh` with `devops::k9s::internal::main::factory` dispatcher
- [x] 2.2 Implement auto-install guard for k9s (`core::exists k9s || core::install k9s`)

## 3. Internal: Create kubectl internal functions

- [x] 3.1 Create `internal/kubectl.zsh` with `devops::kubectl::internal::main::factory` dispatcher
- [x] 3.2 Port `kubectl::internal::load::completion` → `devops::kubectl::internal::load::completion`
- [x] 3.3 Port `kubectl::internal::krew::install` → `devops::kubectl::internal::krew::install`
- [x] 3.4 Port `kubectl::internal::kubecolor::install` → `devops::kubectl::internal::kubecolor::install`
- [x] 3.5 Port `kubectl::internal::krew::load` → `devops::kubectl::internal::krew::load`
- [x] 3.6 Port `kubectl::internal::crossplane::install` → `devops::kubectl::internal::crossplane::install`
- [x] 3.7 Port `kubectl::internal::plugin::install` → `devops::kubectl::internal::plugin::install`
- [x] 3.8 Port `kubectl::internal::plugins::install` → `devops::kubectl::internal::plugins::install`
- [x] 3.9 Port `kubectl::go::internal::packages::install` → `devops::kubectl::go::internal::packages::install`

## 4. Internal: Create helm internal functions

- [x] 4.1 Create `internal/helm.zsh` with `devops::helm::internal::main::factory` dispatcher
- [x] 4.2 Implement auto-install guard for helm (`core::exists helm || core::install helm`)

## 5. Internal: Create tfenv internal functions

- [x] 5.1 Create `internal/tfenv.zsh` with `devops::tfenv::internal::main::factory` dispatcher
- [x] 5.2 Port `tfenv::internal::tfenv::install` → `devops::tfenv::internal::tfenv::install`
- [x] 5.3 Port `tfenv::internal::tfenv::load` → `devops::tfenv::internal::tfenv::load`
- [x] 5.4 Port `tfenv::internal::version::all::install` → `devops::tfenv::internal::version::all::install`
- [x] 5.5 Port `tfenv::internal::version::global::install` → `devops::tfenv::internal::version::global::install`
- [x] 5.6 Port `tfenv::internal::tfenv::upgrade` → `devops::tfenv::internal::tfenv::upgrade`
- [x] 5.7 Implement auto-install guard for terragrunt and terraform-docs

## 6. Internal: Update dispatcher

- [x] 6.1 Update `internal/main.zsh` to source `k9s.zsh`, `kubectl.zsh`, `helm.zsh`, `tfenv.zsh`

## 7. Pkg: Create k9s public API

- [x] 7.1 Create `pkg/k9s.zsh` with `devops::k9s::pkg::main::factory` dispatcher
- [x] 7.2 Port `k9s::sync` → `devops::k9s::sync`
- [x] 7.3 Create `devops::k9s::install`, `devops::k9s::upgrade`, `devops::k9s::post_install`

## 8. Pkg: Create kubectl public API

- [x] 8.1 Create `pkg/kubectl.zsh` with `devops::kubectl::pkg::main::factory` dispatcher
- [x] 8.2 Port `kubectl::install` → `devops::kubectl::install`
- [x] 8.3 Port `kubectl::plugins::install` → `devops::kubectl::plugins::install`
- [x] 8.4 Port `kubectl::plugin::install` → `devops::kubectl::plugin::install`
- [x] 8.5 Port `kubectl::after::install` → `devops::kubectl::after::install`
- [x] 8.6 Port `kubectl::go::packages::install` → `devops::kubectl::go::packages::install`
- [x] 8.7 Port `kubectl::go::package::install` → `devops::kubectl::go::package::install`
- [x] 8.8 Port all 20+ kubectl aliases (k, kubectl, kg, kd, kdel, kucx, kgcx, kscn, kgp, kdp, kgd, kdd, kgs, kds, ka, kl, klf) to `pkg/kubectl.zsh`

## 9. Pkg: Create helm public API

- [x] 9.1 Create `pkg/helm.zsh` with `devops::helm::pkg::main::factory` dispatcher
- [x] 9.2 Implement `devops::helm::install`, `devops::helm::upgrade`, `devops::helm::post_install`

## 10. Pkg: Create tfenv public API

- [x] 10.1 Create `pkg/tfenv.zsh` with `devops::tfenv::pkg::main::factory` dispatcher
- [x] 10.2 Port `tfenv::install` → `devops::tfenv::install`
- [x] 10.3 Port `tfenv::load` → `devops::tfenv::load`
- [x] 10.4 Port `tfenv::post_install` → `devops::tfenv::post_install`
- [x] 10.5 Port `tfenv::upgrade` → `devops::tfenv::upgrade`
- [x] 10.6 Port `tfenv::install::versions` → `devops::tfenv::install::versions`
- [x] 10.7 Port `tfenv::install::version::global` → `devops::tfenv::install::version::global`

## 11. Pkg: Update dispatcher

- [x] 11.1 Update `pkg/main.zsh` to source `k9s.zsh`, `kubectl.zsh`, `helm.zsh`, `tfenv.zsh`

## 12. K9s config files

- [x] 12.1 Create `conf/k9s/config.yml` with k9s settings (refreshRate, logger, clusters, thresholds)
- [x] 12.2 Create `conf/k9s/alias.yml` with pod/resource aliases
- [x] 12.3 Create `conf/k9s/plugin.yml` with k9s plugins (get-all, delete-ctx)

## 13. Plugin entry point

- [x] 13.1 Update `plugin.zsh` to source new config, internal, and pkg files
- [x] 13.2 Verify guard variable `__ZSH_DEVOPS_LOADED` covers all new sources

## 14. Cleanup

- [x] 14.1 Remove empty stub files no longer needed (`internal/helper.zsh`, `internal/osx.zsh`, `internal/linux.zsh`, `pkg/helper.zsh`, `pkg/alias.zsh`, `pkg/osx.zsh`, `pkg/linux.zsh`)
- [x] 14.2 Verify lint with `task validate` passes
- [x] 14.3 Remove K9S_MESSAGE_RVM from zsh/core/config/env.zsh if no longer referenced (check all modules)