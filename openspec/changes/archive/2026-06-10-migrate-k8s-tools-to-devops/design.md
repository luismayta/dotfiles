## Context

The `zsh/modules/devops/` module currently manages DevOps tooling (sops, packer, telepresence) with 5 functions across `config/`, `internal/`, and `pkg/` layers. Four external repos (zsh-k9s, zsh-kubectl, zsh-helm, zsh-tfenv) each follow the same architectural pattern — entry point sources `config/main.zsh` → `core/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`, with OS-dispatch via `$OSTYPE` in each layer's `main.zsh`.

All four repos depend on `zsh-core` (functions like `core::exists`, `core::install`, `message_info`, `message_success`). They are logically DevOps tooling but live outside the monorepo, creating synchronization overhead.

### Current devops module structure
```
zsh/modules/devops/
├── plugin.zsh              # Entry point, guard __ZSH_DEVOPS_LOADED
├── config/
│   ├── base.zsh            # DEVOPS_TOOLS, DEVOPS_PACKAGES
│   ├── main.zsh            # OS-dispatch loader
│   ├── osx.zsh             # DEVOPS_APPLICATION_PATH
│   └── linux.zsh           # DEVOPS_ARCHITECTURE_NAME
├── internal/
│   ├── main.zsh            # OS-dispatch loader
│   └── base.zsh            # devops::internal::packages::install
├── pkg/
│   ├── main.zsh            # OS-dispatch loader
│   └── base.zsh            # devops::install, post_install, upgrade, packages::install
```

### Target: integrated module structure
```
zsh/modules/devops/
├── plugin.zsh              # Updated: sources all new layers
├── config/
│   ├── base.zsh            # Existing + DEVOPS_K9S_*, DEVOPS_KUBECTL_*, DEVOPS_HELM_*, DEVOPS_TFENV_* vars
│   ├── main.zsh            # Updated: sources all config sub-files
│   ├── osx.zsh             # Existing
│   └── linux.zsh           # Existing
├── internal/
│   ├── main.zsh            # Updated dispatcher
│   ├── base.zsh            # Existing + updated install loop
│   ├── k9s.zsh             # devops::k9s::internal::* functions
│   ├── kubectl.zsh         # devops::kubectl::internal::* functions (krew, kubecolor, crossplane, completion)
│   ├── helm.zsh            # devops::helm::internal::* functions
│   └── tfenv.zsh           # devops::tfenv::internal::* functions (install, load, versions)
├── pkg/
│   ├── main.zsh            # Updated dispatcher
│   ├── base.zsh            # Existing + devops::<tool>::install/upgrade wrappers
│   ├── kubectl.zsh         # devops::kubectl::* public API + 20+ aliases
│   ├── helm.zsh            # devops::helm::* public API
│   ├── k9s.zsh             # devops::k9s::sync + public API
│   └── tfenv.zsh           # devops::tfenv::* public API (install, load, versions)
├── conf/
│   └── k9s/                # k9s YAML config files (config.yml, alias.yml, plugin.yml)
```

## Goals / Non-Goals

**Goals:**
- Migrate all functionality from 4 external repos into `zsh/modules/devops/` without losing any features
- Rename namespaces to `devops::<tool>::*` following monorepo conventions
- Consolidate env vars under `DEVOPS_*` prefix
- Maintain exact same initialization guards (auto-install on missing binary)
- Preserve kubectl aliases and k9s configuration syncing
- Implement proper `devops::helm::*` namespace (currently template code)
- Remove `core/` layer from migrated code — it was empty placeholder in all repos

**Non-Goals:**
- No changes to `zsh/core/` library — all dependencies remain unchanged
- No changes to external repos themselves — they will be deprecated separately
- No new tool auto-discovery beyond what already exists
- No CI/CD changes in this change
- No removal of existing devops tools (sops, packer, telepresence)

## Decisions

1. **Namespace convention: `devops::<tool>::<layer>::<action>`**
   - Rationale: Avoids global namespace pollution while making tool ownership explicit. Matches the existing `devops::internal::*` pattern.
   - Example: `kubectl::internal::krew::install` → `devops::kubectl::internal::krew::install`
   - Alternatives considered: Flat `devops::kubectl_krew::install` — rejected for inconsistency with existing convention.

2. **One file per tool in internal/ and pkg/** (not one directory per tool)
   - Rationale: The devops module is already flat. Each tool's internal logic and public API fit in single files. Avoids deep nesting.
   - Structure: `internal/k9s.zsh`, `internal/kubectl.zsh`, `internal/helm.zsh`, `internal/tfenv.zsh` — same for `pkg/`.
   - Alternatives considered: `internal/k9s/base.zsh` subdirectory per tool — rejected; adds complexity without benefit for this scale.

3. **Remove `core/` layer entirely**
   - Rationale: All 4 repos have empty `core/` directories with placeholder files. The monorepo already has `zsh/core/` as the shared layer.
   - Migration: Simply drop `core/` import lines from entry points.

4. **Config vars use `DEVOVS_K9S_*`, `DEVOPS_KUBECTL_*` prefix, not tool prefix**
   - Rationale: All tools live under the devops namespace. Using `K9S_*` would conflict with standalone k9s env vars.
   - Example: `K9S_CONF_DIR` → `DEVOPS_K9S_CONF_DIR`, `KUBECTL_PACKAGE_NAME` → `DEVOPS_KUBECTL_PACKAGE_NAME`

5. **k9s conf/ directory moves to `zsh/modules/devops/conf/k9s/`**
   - Rationale: The YAML config files are infrastructure-as-data that should be tracked alongside the module code. Keeping them in a `conf/` subdirectory follows the existing monorepo pattern.

6. **zsh-helm (currently template) receives full implementation matching the tool pattern**
   - Rationale: The repo exists but never graduated from template. Now is the time to implement proper helm:: namespace with install, upgrade, post_install lifecycle matching k9s/kubectl/tfenv.

## Risks / Trade-offs

- [Breaking change for external consumers] → The external repos will be deprecated. Any direct `source` of the standalone repos must point to `zsh/modules/devops/plugin.zsh`.
- [Function name collision] → Namespace isolation (`devops::k9s::*`) prevents collision with other modules. The existing `devops::*` namespace is preserved.
- [zsh-helm has no real implementation yet] → Creates opportunity but also risk of shipping untested code. Implementation must follow the same patterns as k9s/kubectl/tfenv for consistency.
- [k9s YAML conf files need manual rsync mechanism] → Maintain `devops::k9s::sync` from the original. It rsyncs from `$DEVOPS_PATH/conf/k9s/` to `$K9S_CONF_DIR`.

## Migration Plan

1. Update `config/base.zsh` — add `DEVOPS_K9S_*`, `DEVOPS_KUBECTL_*`, `DEVOPS_HELM_*`, `DEVOPS_TFENV_*` env vars
2. Create `internal/k9s.zsh` — port `k9s::internal::*` → `devops::k9s::internal::*`
3. Create `internal/kubectl.zsh` — port all 8 `kubectl::internal::*` functions
4. Create `internal/helm.zsh` — implement `devops::helm::internal::*` lifecycle
5. Create `internal/tfenv.zsh` — port all 5 `tfenv::internal::*` functions
6. Create `pkg/k9s.zsh` — port `k9s::sync` + `editk9s` → `devops::k9s::*`
7. Create `pkg/kubectl.zsh` — port all 6 `kubectl::pkg::*` functions + 20+ aliases
8. Create `pkg/helm.zsh` — implement `devops::helm::*` public API
9. Create `pkg/tfenv.zsh` — port all 6 `tfenv::pkg::*` functions
10. Create `conf/k9s/` — copy config.yml, alias.yml, plugin.yml
11. Update `plugin.zsh` — add new source lines, remove stub files
12. Update `internal/main.zsh` and `pkg/main.zsh` dispatchers — add new file sources
13. Clean up stub/empty files no longer needed (osx.zsh, linux.zsh, helper.zsh in some subdirs)

## Open Questions

- Should `devops::upgrade` (currently a warning stub) be implemented to upgrade tools, or removed?
- Should k9s YAML files be symlinked or rsynced? (Original uses rsync via `k9s::sync`)