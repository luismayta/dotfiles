# Design

## Context

The devops module (`zsh/modules/devops/`) follows a three-layer architecture: `config/` (env vars) → `internal/` (private `devops::<tool>::internal::*` functions) → `pkg/` (public `devops::<tool>::*` API). Each layer is wired via `source` lines in its own `main.zsh`, and tools are registered in the `DEVOPS_TOOLS` array in `config/base.zsh`. The guide `docs/guides/implement-tool-in-module.md` documents two integration patterns: shell-hooks (eval-based) and PATH-only.

rclone (https://rclone.org/) is a standalone CLI for multi-provider cloud file sync/copy (S3, Google Drive, SFTP, etc.). It has no shell hooks — no keybindings, no completions to eval — so it applies the PATH-only pattern, same as the existing `caddy` and `bruno` tools. Core helpers already exist: `core::exists`, `core::install`, `core::ensure`, `message_info`, `message_success`, `message_error` (defined in `zsh/system/core/pkg/base.zsh` / `zsh/system/core/internal/api.zsh`).

## Goals / Non-Goals

**Goals:**
- Integrate rclone as a first-class devops tool following the guide and the caddy reference implementation exactly
- Auto-install rclone on module load when missing, via the factory pattern
- Expose a stable public API `devops::rclone::{install,upgrade,post_install}`

**Non-Goals:**
- No shell-hook/eval integration (rclone provides none)
- No rsync-based config sync or `data/rclone/` templates (rclone manages its own config in `~/.config/rclone/`)
- No wrapper subcommands around rclone operations (sync/copy/mount) — users call rclone directly
- No cross-platform install scripting beyond what `core::install` abstracts

## Decisions

- **PATH-only pattern over shell-hooks**: rclone has no shell integration to load; the binary on PATH is sufficient. Chosen over the eval pattern because there is nothing to evaluate. Alternative considered: adding completions via `rclone genautocomplete` — deferred, can be added later as a load-time enhancement without spec changes.
- **Follow the caddy reference verbatim for structure**: `config/rclone.zsh` exports `DEVOPS_RCLONE_PACKAGE_NAME=rclone` and `DEVOPS_RCLONE_CONFIG_DIR="${HOME}/.config/rclone"`; `internal/rclone.zsh` defines `load` (guarded by `core::exists rclone`), `install` (via `core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"`, idempotent when already installed), `upgrade` (falls back to install when missing), and `main::factory` (`core::ensure rclone`), ending with load + factory invocations so auto-install fires on module load. Alternative considered: bruno-style custom installer — rejected, rclone is available in native package managers.
- **Package-manager installation via `core::install`**: no hardcoded install commands (no curl-to-shell), keeping the tool consistent with the module's abstraction over brew/apt/pacman. rclone is packaged natively on the supported platforms.
- **`post_install` as guidance, not action**: `devops::rclone::post_install` prints next-step guidance (`rclone config` to create remotes, `rclone listremotes` to inspect them) via `message_info`, because rclone configuration is interactive and per-user. Alternative considered: auto-running `rclone config` — rejected, interactive TTY flow doesn't belong in module load.
- **Wiring via the three `main.zsh` files**: one `source "${DEVOPS_PATH}/<layer>/rclone.zsh"` line per layer, plus the `rclone` entry in `DEVOPS_TOOLS` (alphabetical position in the array).

## Risks / Trade-offs

- [Package name differs across platforms (`rclone` vs a cask/variant)] → `core::install` abstracts the package manager; the package-name variable allows a per-OS override in config later without touching internal/pkg layers.
- [Auto-install on every shell load could surprise users on restricted networks] → `core::ensure` is idempotent and only installs when the binary is absent; the factory pattern is already trusted by other tools (caddy).
- [rclone config dir assumption (`~/.config/rclone`)] → only used for informational guidance; rclone itself resolves its config location (`RCLONE_CONFIG`/XDG), so no behavioral break if it differs.
- [No shell completions shipped] → acceptable for a PATH-only tool; completions can be added via a load-time `source <(rclone genautocomplete zsh)` later without breaking the public API.

## Migration Plan

Not applicable — additive change, no existing behavior modified. Rollback = remove the three rclone files, the `DEVOPS_TOOLS` entry, and the three source lines.

## Open Questions

None.