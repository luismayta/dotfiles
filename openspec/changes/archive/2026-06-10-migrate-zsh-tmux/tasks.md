## 1. Module Structure

- [x] 1.1 Create `zsh/modules/tmux/` directory and subdirectories (`config/`, `internal/`, `pkg/`, `data/conf/`, `data/sync/tmux/`, `data/sync/tmuxinator/templates/`)
- [x] 1.2 Create `zsh/modules/tmux/plugin.zsh` with idempotency guard (`__ZSH_TMUX_LOADED`) and source chain (`config/main` → `internal/main` → `pkg/main`)

## 2. Config Layer

- [x] 2.1 Create `zsh/modules/tmux/config/main.zsh` with OS dispatch sourcing `base.zsh` → `osx.zsh`/`linux.zsh`
- [x] 2.2 Create `zsh/modules/tmux/config/base.zsh` with `HOME_CONFIG_PATH`, `TMUX_FILE_SETTINGS`, `TMUX_MESSAGE_BREW`, `TMUX_MESSAGE_RVM`, `TMUX_PACKAGE_NAME`, `TMUX_CONFIG_DIR`, `TMUX_TPM_PATH`, `TMUXINATOR_TEMPLATE_DIR`, `TMUXINATOR_DEFAULT_TEMPLATE`, and `EDITOR` fallback
- [x] 2.3 Create `zsh/modules/tmux/config/osx.zsh` (placeholder)
- [x] 2.4 Create `zsh/modules/tmux/config/linux.zsh` (placeholder)

## 3. Internal Layer

- [x] 3.1 Create `zsh/modules/tmux/internal/main.zsh` with OS dispatch sourcing `base.zsh` → `osx.zsh`/`linux.zsh`, plus `core::exists` guards for `rsync`, `fzf`, `tmux`, and TPM install
- [x] 3.2 Create `zsh/modules/tmux/internal/base.zsh` with `tmux::internal::tmux::install`, `tmux::internal::tmuxinator::install`, `tmux::internal::tpm::install`
- [x] 3.3 Create `zsh/modules/tmux/internal/osx.zsh` with `reattach-to-user-namespace` install check
- [x] 3.4 Create `zsh/modules/tmux/internal/linux.zsh` (placeholder)

## 4. Package Layer

- [x] 4.1 Create `zsh/modules/tmux/pkg/main.zsh` sourcing `base.zsh` → `helper.zsh` → `alias.zsh` with OS dispatch for `osx.zsh`/`linux.zsh`
- [x] 4.2 Create `zsh/modules/tmux/pkg/base.zsh` with `tmux::dependences`, `tmux::install`, `tmux::post_install`, `tmux::sync`, plus auto-invoke load and auto-install if `tmux` not found
- [x] 4.3 Create `zsh/modules/tmux/pkg/helper.zsh` with `edittmux`, `tx::project`, `ftm`, `ftmk` functions
- [x] 4.4 Create `zsh/modules/tmux/pkg/alias.zsh` with `tx=tmuxinator` alias guard
- [x] 4.5 Create `zsh/modules/tmux/pkg/osx.zsh` (placeholder)
- [x] 4.6 Create `zsh/modules/tmux/pkg/linux.zsh` (placeholder)

## 5. Data Files

- [x] 5.1 Copy `data/conf/.tmux.conf` from source (tmux core settings, catppuccin theme, TPM plugins, vi mode, key bindings)
- [x] 5.2 Copy `data/sync/tmux/osx.conf` (macOS clipboard integration with `reattach-to-user-namespace`)
- [x] 5.3 Copy `data/sync/tmux/linux.conf` (Linux clipboard integration for `pbcopy`/`xclip`/`wl-copy`)
- [x] 5.4 Create `data/sync/tmuxinator/templates/` directory placeholder

## 6. Remove External Dependency

- [x] 6.1 Remove `hadenlabs/zsh-tmux` from `zsh/zsh_plugins.txt` (already absent — no action needed)

## 7. Verification

- [x] 7.1 Source module in subshell and confirm no errors — all 19 files pass `zsh -n`
- [x] 7.2 Verify all 11 functions defined — all confirmed via `typeset -f`
- [x] 7.3 Verify idempotent loading — `__ZSH_TMUX_LOADED` guard returns early on second source
- [x] 7.4 Run `task validate` — shellcheck, codespell, gitleaks, markdown-link-check all pass
