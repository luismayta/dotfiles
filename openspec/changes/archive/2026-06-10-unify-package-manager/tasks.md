## 1. Config: Add paru support variables

- [x] 1.1 Add `CORE_MESSAGE_PARU` to `zsh/core/config/env.zsh`
- [x] 1.2 Populate `zsh/core/config/linux.zsh` with paru PATH and config
- [x] 1.3 Verify `zsh/core/config/paths.zsh` includes paru standard paths

## 2. Core: OS-specific override files for install

- [x] 2.1 Change `core::internal::core::install()` in `zsh/core/internal/api.zsh` to a base stub: print unsupported OS error and return 1
- [x] 2.2 Add `core::internal::core::install()` override in `zsh/core/internal/osx.zsh` with `brew install` logic (moved from api.zsh + brew exists check with `CORE_MESSAGE_BREW`)
- [x] 2.3 Add `core::internal::core::install()` override in `zsh/core/internal/linux.zsh` with `paru -S --noconfirm` logic (paru exists check with `CORE_MESSAGE_PARU`)
- [x] 2.4 Implement `core::internal::multiplatform::install()` with OS-aware dispatch (macOS → brew bundle / Linux → paru group installs)

## 3. Linux package compatibility

- [x] 3.1 Review `zsh/core/pkg/helper/core.zsh` — auto-installed packages (axel, ripgrep, fzf, jq, bat, coreutils, the_silver_searcher) — ensure they work via `paru` on Arch/CachyOS
- [x] 3.2 Update `zsh/core/pkg/linux.zsh` if needed — `core::install xclip` should route through paru (already handled by api.zsh dispatch)
- [x] 3.3 Verify `zsh/core/pkg/alias.zsh` eza auto-install works on Linux via paru

## 4. archlinux.sh: Migrate from yay to paru

- [x] 4.1 Replace `yay` with `paru` in `archlinux.sh` — change `go get github.com/Jguer/yay` to `sudo pacman -S --noconfirm paru` (already done in install.sh)
- [x] 4.2 Change all `yay -S --noconfirm` calls to `paru -S --noconfirm`

## 5. Remove inconsistent package manager references

- [x] 5.1 Remove `apt-get` fallback from `zsh/modules/ghq/internal/base.zsh`; use OS-dispatch via `core::install` instead
- [x] 5.2 Ensure no other `apt-get` references remain across the codebase

## 6. Final verification

- [x] 6.1 Run `lsp_diagnostics` on all modified files to catch syntax errors
- [x] 6.2 Verify `zsh/core/main.zsh` chains correctly (no circular dependencies)
- [x] 6.3 Manual check: `core::install`, `core::exists`, `core::ensure` public API unchanged