# Proposal

## Why

The devops module lacks rclone, the de-facto standard for multi-provider (S3, Google Drive, SFTP, etc.) file sync and copy. Integrating it as a module tool gives users managed install/upgrade and post-install guidance, consistent with every other tool in the module.

## What Changes

- Add `rclone` as a new PATH-only tool in `zsh/modules/devops/`, following the `docs/guides/implement-tool-in-module.md` guide (rclone is a standalone CLI with no shell hooks):
  - `config/rclone.zsh` — `DEVOPS_RCLONE_*` variables (`PACKAGE_NAME`, `CONFIG_DIR`)
  - `internal/rclone.zsh` — `devops::rclone::internal::{load,install,upgrade,main::factory}` with `core::exists rclone` guard, `core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"`, and auto-install via factory
  - `pkg/rclone.zsh` — public wrappers `devops::rclone::install`, `devops::rclone::upgrade`, `devops::rclone::post_install` (guidance: `rclone config`, `rclone listremotes`)
- Register `rclone` in the `DEVOPS_TOOLS` array in `config/base.zsh`
- Wire `source` lines in `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`

No breaking changes.

## Capabilities

### New Capabilities

- `devops-rclone`: lifecycle of the rclone tool inside the devops module (config vars, PATH-only load guard, native package-manager install/upgrade, auto-install on module load, public API, post-install guidance)

### Modified Capabilities

(none)

## Impact

- New files: `zsh/modules/devops/config/rclone.zsh`, `zsh/modules/devops/internal/rclone.zsh`, `zsh/modules/devops/pkg/rclone.zsh`
- Modified files: `zsh/modules/devops/config/base.zsh` (DEVOPS_TOOLS), `zsh/modules/devops/config/main.zsh`, `zsh/modules/devops/internal/main.zsh`, `zsh/modules/devops/pkg/main.zsh` (source wiring)
- Dependencies: `rclone` installed via the native package manager through `core::install`; existing core helpers `core::exists`, `core::install`, `core::ensure`, `message_info`, `message_success`, `message_error`