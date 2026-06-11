## Why

Three tool installer scripts in `tools/` (`antibody`, `brew`, `wakatime`) are dead code — they are not listed in the `APPS` array, so `dotfiles_install_apps()` never invokes them. They contain outdated references, undefined variables, and orphan logic. Meanwhile, the 3 active tool installers (`git-extras`, `fonts`, `antidote`) lack `set -euo pipefail` hardening and proper error handling.

## What Changes

1. **Remove `tools/antibody/`** — Dead. Replaced by `antidote` (antidote plugin manager). No references to antibody remain anywhere in the codebase.
2. **Remove `tools/brew/`** — Dead. Brew installation lives in `install.sh` (`setup::mac`). This script is never called and contains outdated Intel-only paths (`/usr/local/bin`).
3. **Remove `tools/wakatime/`** — Dead. Not in `APPS`. References undefined variables (`PATH_WAKATIME`, `NAME_WAKATIME_BASH`, `URL_WAKATIME_BASH` — the last exists in `config/base.sh` but that config is scoped to the provision pipeline, not sourced by the installer directly).
4. **Harden active tool installers** — Apply `set -euo pipefail`, `readonly` constants, `exit 1` codes, `trap ... ERR`, and `local` scoping to the 3 active installers (`git-extras`, `fonts`, `antidote`).

## Capabilities

### New Capabilities

- `dead-tool-removal`: Remove 3 unused tool installer directories (antibody, brew, wakatime) and their artifacts from the repository
- `tool-installer-hardening`: Harden the 3 active tool installer scripts (git-extras, fonts, antidote) with strict mode, error handling, and proper scoping

### Modified Capabilities

- *None* — no existing spec-driven capabilities are being modified

## Impact

- **Removed files:** ~103 lines in 3 directories (`tools/antibody/install.sh`, `tools/brew/install.sh`, `tools/wakatime/install.sh`)
- **Modified files:** 3 active installers in `tools/git-extras/install.sh`, `tools/fonts/install.sh`, `tools/antidote/install.sh`
- **Zero runtime impact** — dead code removal has no effect on active code paths
- **Consistency** — active installers will match the hardening pattern already applied to `install.sh` and `provision/script/*`