## Why

The dotfiles package installation layer (`zsh/core/internal/api.zsh`) currently hardcodes `brew install` as the universal package manager, regardless of OS. On Linux (CachyOS/Arch), this fails silently or produces incorrect results. Additionally, there are inconsistencies across the codebase — `archlinux.sh` uses `yay` while `install.sh` uses `paru`, and some modules reference `apt-get` which contradicts the project's stated Linux support for only CachyOS/Arch. This makes the dotfiles unreliable on Linux and creates confusion during bootstrap.

## What Changes

1. **`zsh/core/internal/api.zsh`** — `core::internal::core::install()` becomes a base stub that errors on unsupported OS (safety net for non-macOS/non-Linux)
2. **`zsh/core/internal/osx.zsh`** — Override `core::internal::core::install()` with `brew install` logic (currently hardcoded in api.zsh)
3. **`zsh/core/internal/linux.zsh`** — New override `core::internal::core::install()` with `paru -S --noconfirm` logic
4. **`zsh/core/config/env.zsh`** — Add `CORE_MESSAGE_PARU` message variable
5. **`zsh/core/config/paths.zsh`** — Ensure paru bin path is available on Linux
6. **`zsh/core/config/linux.zsh`** — Populate with paru-related PATH/config (currently empty)
7. **`zsh/core/pkg/linux.zsh`** — `core::install` calls route through the linux.zsh override
8. **`archlinux.sh`** — Migrate from `yay` to `paru` to match `install.sh`
9. **`zsh/modules/ghq/internal/base.zsh`** — Remove `apt-get` fallback (only Arch/CachyOS supported on Linux)
10. **`zsh/core/internal/multiplatform::install()`** — Implement actual multi-platform dispatch (currently a no-op warning)
11. **`zsh/core/pkg/helper/core.zsh`** — Auto-installed packages route through correct OS-aware layer

## Capabilities

### New Capabilities
- `os-aware-install`: Core install layer that dispatches to `brew` on macOS and `paru` on Linux (CachyOS/Arch), removing the hardcoded brew dependency
- `paru-integration`: Linux package management via paru with proper PATH and config support

### Modified Capabilities
- *(No existing specs in `openspec/specs/` are modified — this is a new cross-cutting concern)*

## Impact

- **`zsh/core/`** — `internal/api.zsh` (core install logic), `config/env.zsh` (messages), `config/paths.zsh` (bin path), `config/linux.zsh` (was empty), `pkg/linux.zsh` (capabilities dispatch), `pkg/helper/core.zsh` (auto-installs)
- **`install.sh`** — Already correct, no changes needed
- **`archlinux.sh`** — `yay` → `paru` migration
- **`zsh/modules/ghq/internal/base.zsh`** — Remove `apt-get` branch
- **No breaking API changes** — Public API (`core::install`, `core::exists`, `core::ensure`) remains identical; only internal dispatch changes
