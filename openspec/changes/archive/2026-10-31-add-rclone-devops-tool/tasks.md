# Tasks

## 1. Config layer

- [x] 1.1 Create `zsh/modules/devops/config/rclone.zsh` with `#!/usr/bin/env ksh` shebang exporting `DEVOPS_RCLONE_PACKAGE_NAME=rclone` and `DEVOPS_RCLONE_CONFIG_DIR="${HOME}/.config/rclone"` (verify: file exists and `source zsh/modules/devops/config/rclone.zsh` defines both variables)

## 2. Internal layer

- [x] 2.1 Create `zsh/modules/devops/internal/rclone.zsh` with `devops::rclone::internal::load` (guard `if ! core::exists rclone; then return; fi`), `devops::rclone::internal::install` (idempotent; `core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"` with `message_info`/`message_success`), `devops::rclone::internal::upgrade` (falls back to install when missing), and `devops::rclone::internal::main::factory` (`core::ensure rclone`), ending with load + factory invocations (verify: `type devops::rclone::internal::install` returns "function" after sourcing)

## 3. Public API layer

- [x] 3.1 Create `zsh/modules/devops/pkg/rclone.zsh` with wrappers `devops::rclone::install`, `devops::rclone::upgrade`, and `devops::rclone::post_install` printing guidance (`rclone config`, `rclone listremotes`) via `message_info` (verify: `type devops::rclone::install` returns "function" and post_install output mentions both commands)

## 4. Registration and wiring

- [x] 4.1 Add `rclone` to the `DEVOPS_TOOLS` array in `zsh/modules/devops/config/base.zsh` in alphabetical order (verify: `echo $DEVOPS_TOOLS` contains `rclone`)
- [x] 4.2 Add `source "${DEVOPS_PATH}/config/rclone.zsh"`, `source "${DEVOPS_PATH}/internal/rclone.zsh"`, and `source "${DEVOPS_PATH}/pkg/rclone.zsh"` to `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh` respectively, following existing `# shellcheck source=/dev/null` conventions (verify: each main.zsh contains its rclone source line)

## 5. Integration verification

- [x] 5.1 Verify the module loads cleanly: run `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh` and confirm no errors and `type devops::rclone::install` returns "function" (verify: command exits 0 with function output)
- [x] 5.2 Verify auto-install: with `rclone` absent from PATH, loading the module triggers `devops::rclone::internal::install`; with rclone present, loading performs no install (verify: observe install messages only in the missing case)
- [x] 5.3 Verify conventions: grep the three rclone files for bare `echo` usage and single-underscore prefixes (`devops_rclone_`) and confirm neither appears (verify: grep returns no matches)

## Workflow follow-up

- Archive the change after the project's review requirements are satisfied.
- Verify the archived result.