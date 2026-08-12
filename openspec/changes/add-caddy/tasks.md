## 1. Scaffold module files

- [x] 1.1 Create `zsh/modules/devops/config/caddy.zsh` with `DEVOPS_CADDY_*` env vars (`PACKAGE_NAME=caddy`, install command/url per platform, config dir `${HOME}/.config/caddy`)
- [x] 1.2 Create `zsh/modules/devops/internal/caddy.zsh` with `devops::caddy::internal::{load,install,upgrade,main::factory}`; `load` guards with `core::exists caddy`; file ends with `devops::caddy::internal::load` and `devops::caddy::internal::main::factory`
- [x] 1.3 Create `zsh/modules/devops/pkg/caddy.zsh` with public wrappers `devops::caddy::{install,upgrade,post_install}` (and `load`/`sync` if applicable); `post_install` prints usage guidance (`caddy run`, `caddy file-server`, `caddy reverse-proxy`)

## 2. Register caddy in the module

- [x] 2.1 Add `source "${DEVOPS_PATH}/config/caddy.zsh"` to `zsh/modules/devops/config/main.zsh`
- [x] 2.2 Add `source "${DEVOPS_PATH}/internal/caddy.zsh"` to `zsh/modules/devops/internal/main.zsh`
- [x] 2.3 Add `source "${DEVOPS_PATH}/pkg/caddy.zsh"` to `zsh/modules/devops/pkg/main.zsh`
- [x] 2.4 Add `"caddy"` to the `DEVOPS_TOOLS` array in `zsh/modules/devops/config/base.zsh`

## 3. Implement install (internal)

- [x] 3.1 Implement idempotent availability check (`core::exists caddy` guard) so re-running install is a no-op when present
- [x] 3.2 Implement per-platform install via `core::install caddy` (brew on macOS; apt/official script on Linux)

## 4. Implement helpers (pkg)

- [x] 4.1 `devops::caddy::install` delegates to the internal install
- [x] 4.2 `devops::caddy::upgrade` delegates to `caddy upgrade`
- [x] 4.3 `devops::caddy::post_install` prints usage guidance for `caddy run`, `caddy file-server`, `caddy reverse-proxy`

## 5. Validate

- [x] 5.1 Run `openspec validate` on the change
- [x] 5.2 Run `shellcheck` on the new zsh files
- [x] 5.3 Confirm the devops module sources without errors and `caddy` resolves when installed
