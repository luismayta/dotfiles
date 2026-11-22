# Tasks

## 1. Config layer

- [x] 1.1 Create `zsh/modules/devops/config/mise.zsh` with shebang `#!/usr/bin/env ksh`, exporting `DEVOPS_MISE_PACKAGE_NAME=mise`, `DEVOPS_MISE_NIX_PACKAGE="nixpkgs#mise"`, `DEVOPS_MISE_INIT_FLAGS=()` and mise config paths (`DEVOPS_MISE_CONFIG_DIR`, `DEVOPS_MISE_CONFIG_FILE`), with no install logic — verify: the file exists and `grep -E "core::install|eval|mise activate" zsh/modules/devops/config/mise.zsh` returns no matches.

## 2. Internal layer

- [x] 2.1 Create `zsh/modules/devops/internal/mise.zsh` with `devops::mise::internal::load` guarded by `! core::exists mise` (early return) that otherwise runs `eval "$(mise activate zsh ${DEVOPS_MISE_INIT_FLAGS[@]})"` — verify: sourcing the file defines the function and, with `mise` absent from PATH, no `mise activate` eval is attempted.
- [x] 2.2 Add `devops::mise::internal::install` (short-circuit when `core::exists mise`; skip + warn when `ZSH_NIX_DARWIN_AVAILABLE` is `"true"`; `core::nix::package::install "${DEVOPS_MISE_NIX_PACKAGE}"` when `nix` is in PATH; fallback `core::install "${DEVOPS_MISE_PACKAGE_NAME}"` when nix is absent) and `devops::mise::internal::upgrade` (`core::nix::package::upgrade "${DEVOPS_MISE_NIX_PACKAGE}"` with success/error messages) — verify: `type devops::mise::internal::install` reports `function` and `grep -c "core::install\|core::nix::package::install" zsh/modules/devops/internal/mise.zsh` finds both paths.
- [x] 2.3 Add `devops::mise::internal::main::factory` that calls `devops::mise::internal::install` only when `! core::exists mise`, and call `devops::mise::internal::load` followed by `devops::mise::internal::main::factory` at source time (atuin ordering) — verify: sourcing the file with `mise` missing prints `[INFO]: Installing mise`.

## 3. Public API

- [x] 3.1 Create `zsh/modules/devops/pkg/mise.zsh` exposing `devops::mise::install` (delegates to `devops::mise::internal::main::factory`), `devops::mise::upgrade` (delegates to `devops::mise::internal::upgrade`) and `devops::mise::post_install` printing guidance that includes `mise use node@latest` — verify: after loading the module, `type devops::mise::install`, `type devops::mise::upgrade` and `type devops::mise::post_install` each report `function`.

## 4. Registration and wiring

- [x] 4.1 Add `mise` to the `DEVOPS_TOOLS` array in `zsh/modules/devops/config/base.zsh` — verify: `grep -n "mise" zsh/modules/devops/config/base.zsh` shows `mise` inside the array.
- [x] 4.2 Add the three aggregator lines — `source "${DEVOPS_PATH}/config/mise.zsh"` in `config/main.zsh`, `source "${DEVOPS_PATH}/internal/mise.zsh"` in `internal/main.zsh`, `source "${DEVOPS_PATH}/pkg/mise.zsh"` in `pkg/main.zsh`, each preceded by `# shellcheck source=/dev/null` — verify: `grep -c "mise.zsh" zsh/modules/devops/config/main.zsh zsh/modules/devops/internal/main.zsh zsh/modules/devops/pkg/main.zsh` reports `1` per file.

## 5. Functional verification

- [x] 5.1 Run `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh` in a clean zsh and confirm it exits without errors and without `command not found` output — verify: command completes with status 0 and no error lines mentioning `mise`.
- [x] 5.2 Confirm `type devops::mise::install` reports `function` after module load (public API reachable) — verify: output is `devops::mise::install is a function`.
- [x] 5.3 Confirm factory auto-install: with `mise` not on PATH, loading the module triggers installation and afterwards `command -v mise` succeeds — verify: `[INFO]: Installing mise` (or equivalent `message_info`) appears and `mise --version` runs.
- [x] 5.4 Audit the three new files against the guide checklist: `#!/usr/bin/env ksh` shebang, `devops::mise::` / `devops::mise::internal::` prefixes, `message_info`/`message_success`/`message_error` instead of `echo`, no absolute paths (only `${HOME}` / `$DEVOPS_PATH`), no hardcoded install commands — verify: `grep -n "echo" zsh/modules/devops/{config,internal,pkg}/mise.zsh` returns no matches and each file starts with the ksh shebang.

## Workflow follow-up

- Archive the change once implementation is reviewed and merged.
- Verify the archived result with `openspec status --change "add-mise-devops"`.
