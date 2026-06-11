## Context

The git module ensures `git-flow` is installed via `core::ensure git-flow` in `internal/main.zsh`. On macOS, `brew install git-flow` works fine. On Linux, `paru -S --noconfirm git-flow` fails because the AUR package is named `gitflow-avh` (not `git-flow`).

The git module already has platform-specific config files (`config/linux.zsh`, `config/osx.zsh`) that are sourced before `internal/main.zsh` runs. This is the natural place to define a platform-specific package name override.

The command `git-flow` is available from the `gitflow-avh` AUR package and is also commonly built from source (nvie/gitflow). Using the AUR package is the correct approach on Arch-based systems.

## Goals / Non-Goals

**Goals:**
- Make `core::ensure git-flow` succeed on Linux by providing the correct AUR package name (`gitflow-avh`).
- Follow existing patterns in the module (platform config overrides sourced before internal logic).

**Non-Goals:**
- Changing how git-flow is installed on macOS (brew works fine).
- Changing the git-flow binary name or the `core::ensure` API.
- Adding manual/source-based installation for git-flow.

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| **Override mechanism** | `GIT_FLOW_PACKAGE_NAME` env var set in `config/linux.zsh` | Follows the existing pattern of platform-specific config overrides. macOS already defaults to `git-flow` via the `:-git-flow` fallback. |
| **Default value** | `gitflow-avh` for Linux | This is the correct AUR package. The binary installed is still `git-flow`, so all existing `type -p git-flow` checks and git-flow commands continue working. |
| **Fallback** | `${GIT_FLOW_PACKAGE_NAME:-git-flow}` in `internal/main.zsh` | Ensures backward compatibility — if `config/linux.zsh` is not sourced (e.g., on macOS or a future refactor), it still tries the original package name. |

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `gitflow-avh` is removed from AUR in the future | The fallback to `git-flow` would fail again, but a future change could switch to a manual install from the gitflow GitHub repo. |
| User expects `git-flow` package from another repo | If the user has a custom repo with `git-flow`, they can set `GIT_FLOW_PACKAGE_NAME` in their `.customrc` to override. |