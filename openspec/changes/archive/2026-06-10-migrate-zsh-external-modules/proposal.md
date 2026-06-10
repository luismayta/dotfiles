## Why

Six standalone zsh modules (ghostty, ssh, resources, templates, issues, bitwarden) live in external repos under `hadenlabs/zsh-*`. Each duplicates the same boilerplate (config/ → internal/ → pkg/ factory pattern, OS dispatch, dependency checks, auto-install) and is loaded independently by the dotfiles zshrc. Bringing them in-tree eliminates cross-repo synchronization overhead, ensures consistent module conventions (matching `zsh/modules/rust/` and `zsh/modules/docker/`), and simplifies maintenance by colocating all module code under a single source of truth.

## What Changes

- **Migrate** 6 external repos into `zsh/modules/<name>/` following the rust/docker module pattern:
  - `hadenlabs/zsh-ghostty` → `zsh/modules/ghostty/`
  - `hadenlabs/zsh-ssh` → `zsh/modules/ssh/`
  - `hadenlabs/zsh-resources` → `zsh/modules/resources/`
  - `hadenlabs/zsh-templates` → `zsh/modules/templates/`
  - `hadenlabs/zsh-issues` → `zsh/modules/issues/`
  - `hadenlabs/zsh-bitwarden` → `zsh/modules/bitwarden/`
- **Rename entry point** from `zsh-<name>.zsh` to `plugin.zsh` with idempotency guard (`__ZSH_<NAME>_LOADED`)
- **Rename namespace** from `ZSH_<NAME>_PATH` to `<UPPER_NAME>_PATH` (e.g., `ZSH_GHOSTTY_PATH` → `GHOSTTY_PATH`)
- **Rewrite sourcing chain** to match rust module: `config/main.zsh → internal/main.zsh → pkg/main.zsh`
- **Remove core/ layer** from ghostty module (fold into config/ or internal/)
- **Collapse issues modules special layers** (provider/, workflow/) — keep them but under internal/ conventions
- **Copy data directories** (`conf/`, `templates/`, `resources/`, `assets/`) alongside module code
- **Update zshrc** to source new `plugin.zsh` paths instead of external repos

## Capabilities

### New Capabilities
- `ghostty`: Ghostty terminal configuration management — config sync, install, theme management, config file editing via `editghostty`
- `ssh`: SSH connection manager with fzf — `ssh::connect` (`^Xs`), `ssh::list/build/sync/upgrade`, assh wrapper with alias `ssh=assh`
- `resources`: Font and asset distribution — `resources::fonts::sync`, font directory detection per OS, cached font installation
- `templates`: Template loader with fzf — `templates::run` (`^Xt`), fzf picker → load → clipboard, organized template directories (jira, kubernetes, common)
- `issues`: Issue and PR workflow manager — `issues()` dispatcher (create/search), provider abstraction (GitHub/GitLab), git workflow detection (githubflow/gitflow), chpwd auto-detection
- `bitwarden`: Bitwarden CLI integration — `bw::search` (`fbw`, `^Xk`), fzf-driven item lookup (passwords/notes/cards), clipboard copy via `pbcopy`/`xclip`

### Modified Capabilities
- `zshrc`: Update module loading paths from external repos to `zsh/modules/<name>/plugin.zsh`

## Impact

- **6 external repos** will be deprecated after migration (code moves, no functional changes)
- **zshrc** module sourcing updates (remove external repo paths, add `zsh/modules/<name>/plugin.zsh` paths)
- **Rust module** remains the reference pattern — no changes to it
- **Docker module** remains the reference pattern — no changes to it
- **ZSH_<NAME>_PATH** variables renamed to **<UPPER_NAME>_PATH** (breaking for any external code depending on old var names)
- All 6 modules preserve existing keybindings (`^Xs`, `^Xt`, `^Xk`) as-is
