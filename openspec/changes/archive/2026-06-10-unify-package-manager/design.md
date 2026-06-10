## Context

The `zsh/core/internal/api.zsh` file provides the core install primitive `core::internal::core::install()` which all higher-level wrappers (`core::install`, `core::ensure`) delegate to. Currently it hardcodes `brew install "${@}"` unconditionally — this works on macOS but fails on Linux (CachyOS/Arch). The project's stated Linux support is CachyOS/Arch via `paru`, but multiple inconsistencies exist:

- `archlinux.sh` uses `yay` instead of `paru`
- `zsh/modules/ghq/internal/base.zsh` has an `apt-get` fallback for Debian/Ubuntu
- `zsh/core/config/linux.zsh` is empty
- `core::internal::multiplatform::install()` is a no-op warning
- No `paru` message variable exists in env.zsh

The bootstrap script `install.sh` already has correct OS detection (Darwin→brew, Linux→paru with CachyOS/Arch guard). The runtime layer needs to match.

## Goals / Non-Goals

**Goals:**
- `core::install` dispatches to correct package manager per OS: macOS → `brew`, Linux → `paru`
- All auto-install side-effects (in `pkg/helper/core.zsh`, `pkg/alias.zsh`, `pkg/linux.zsh`) work on both platforms
- `archlinux.sh` uses `paru` consistently with `install.sh`
- Remove Debian/Ubuntu (`apt-get`) references as they contradict the project's Linux support scope
- Proper error messages when package manager is missing

**Non-Goals:**
- Adding new Linux distribution support beyond CachyOS/Arch
- Rewriting the brew module (`zsh/modules/brew/`)
- Changing the public API surface (`core::install`, `core::exists`, `core::ensure` signatures remain identical)
- Supporting Windows/WSL

## Decisions

### 1. OS-specific override pattern (not conditional dispatch)
- **Decision**: `api.zsh` defines a base `core::internal::core::install()` that errors on unsupported OS. Each OS file (`osx.zsh`, `linux.zsh`) overrides the function with its own package manager logic. The loading chain in `internal/main.zsh` loads `api.zsh` first, then the OS file — so zsh naturally picks the OS-specific override at runtime.
- **Rationale**: Zero conditional logic in the shared file. Each OS owns its implementation. If a new OS is ever needed, just add an override file. Follows the existing pattern where `osx.zsh` already overrides `reload()` and `linux.zsh` exists as a placeholder.
- **Alternative considered**: `if/else` on `$OSTYPE` in api.zsh. Rejected — adds noise to the shared file and makes it harder to add OS-specific behavior beyond package management.

### 2. paru presence check before install
- **Decision**: If `paru` is not found on Linux, print a warning with a message about installing paru (`CORE_MESSAGE_PARU`) and skip the installation
- **Rationale**: Matches existing pattern for brew (`CORE_MESSAGE_BREW`). Don't auto-install paru from the runtime layer — that's the bootstrap script's job.

### 3. archlinux.sh migration from yay to paru
- **Decision**: Replace all `yay` calls with `paru` and update the install method from `go get` to `pacman -S`
- **Rationale**: `install.sh` already uses `paru` and `pacman -S paru`. Having two AUR helpers is inconsistent and confusing.

### 4. Remove apt-get from ghq module
- **Decision**: Remove the `apt-get` branch in `zsh/modules/ghq/internal/base.zsh`
- **Rationale**: Project only supports Arch/CachyOS on Linux. `apt-get` fallback is dead code that suggests wider support than exists.

### 5. Implement `core::internal::multiplatform::install()`
- **Decision**: Add OS dispatch to this function: macOS → brew bundle / mas, Linux → paru with group installs
- **Rationale**: Currently a no-op warning. Making it functional completes the multi-platform story.

## Risks / Trade-offs

- **Risk**: `paru -S --noconfirm` may fail if paru database is locked or needs `sudo` — **Mitigation**: `paru` on CachyOS/Arch typically runs without sudo for user packages. If sudo is needed, fail with clear message rather than hanging.
- **Risk**: Existing users on Arch with `yay` will need to migrate — **Mitigation**: Low risk since `install.sh` already provisions `paru`, and `archlinux.sh` is only sourced from provision scripts.
- **Trade-off**: Removing `apt-get` support means Debian/Ubuntu users can't use this dotfiles. This is intentional — the project never claimed to support them.
