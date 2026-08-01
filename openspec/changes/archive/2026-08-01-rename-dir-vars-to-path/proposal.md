## Why

The repo's own naming standard (archived change `2026-06-13-rename-zsh-dir-vars-to-path`, spec `rename-convention`) requires shell variables holding filesystem paths to end in `_PATH`. That rename only covered core/TMUX/devops vars; **16 repo-defined `_DIR` variables remain** across `zsh/`, `provision/`, `bin/` and `tools/`, creating an inconsistent, self-contradicting surface (e.g. `ZSH_NOTIFY_CONFIG_PATH` vs its sibling `ZSH_NOTIFY_NOTI_CONFIG_DIR` in the same module). This change completes the migration and formalizes the convention as a live spec.

## What Changes

- **BREAKING** Rename core bootstrap vars: `DOTFILES_DIR` → `DOTFILES_PATH`, `DOTFILES_ZSH_DIR` → `DOTFILES_ZSH_PATH`, `DOTFILES_SYSTEM_DIR` → `DOTFILES_SYSTEM_PATH` (updates `zsh/zshrc`, `zsh/system/core/config/paths.zsh`, 10 `bin/` scripts using `${DOTFILES_DIR:-...}` fallback, `zsh/system/nix-darwin/`, `~/.zshrc` bootstrap line, and live specs `zshrc-load`, `shared-paths`, `core-api`).
- Rename module config vars to the existing `_CONFIG_PATH`/`_CONF_PATH` convention: `ZSH_NOTIFY_NOTI_CONFIG_DIR` → `ZSH_NOTIFY_NOTI_CONFIG_PATH`, `ZSH_YAZI_CONFIG_DIR` → `ZSH_YAZI_CONFIG_PATH`, `ZSH_HERDR_CONFIG_DIR` → `ZSH_HERDR_CONFIG_PATH`, `NIX_DIRENV_CONFIG_DIR` → `NIX_DIRENV_CONFIG_PATH`, `NIX_CONF_DIR` → `NIX_CONF_PATH`, `DEVOPS_ATUIN_CONFIG_DIR` → `DEVOPS_ATUIN_CONFIG_PATH`.
- Rename provision vars: `SCRIPT_DIR` → `SCRIPT_PATH`, `ZSH_DIR` → `ZSH_PATH`, `TOOLS_DIR` → `TOOLS_PATH`, `ROOT_DIR` → `ROOT_PATH` in `provision/script/`.
- Rename script-local bash vars: `TESTS_DIR` → `TESTS_PATH` (`git/tests/run.sh`), `ANTIDOTE_DIR` → `ANTIDOTE_PATH` (`tools/antidote/install.sh`), local `SCRIPT_DIR` → `SCRIPT_PATH` in `waybar` scripts.
- Delete dead exports instead of renaming: `EXTRAS_DIR` (0 usages), `FONTS_DIR` (1 usage, superseded by `RESOURCES_FONTS_PATH`).
- **Explicitly excluded from migration** (documented in design): `APPS_WEB_APPS_BUILD_DIR` (scratch/build directory, not a config path) and external vars `SDKMAN_DIR`, `XDG_RUNTIME_DIR`, `XDG_CONFIG_HOME` (third-party-owned; renaming would break them).
- Sync stale live spec `devops-k9s` (`DEVOPS_K9S_CONF_DIR` → `DEVOPS_K9S_CONF_PATH`, already renamed in code) and docs (`docs/guides/create-module.md`, `docs/guides/implement-tool-in-module.md`).

## Capabilities

### New Capabilities
- `path-naming-convention`: formalizes the repo rule that shell env vars holding filesystem paths end in `_PATH`; codifies the `_DIR` exclusions (build dirs, third-party-owned vars).

### Modified Capabilities
- `zshrc-load`: `DOTFILES_CORE_PATH` source via bootstrap — update references to `DOTFILES_ZSH_PATH` / `DOTFILES_SYSTEM_PATH`.
- `shared-paths`: exported path variables — update `DOTFILES_ZSH_DIR` → `DOTFILES_ZSH_PATH` and add the three renamed core vars.
- `core-api`: `DOTFILES_CORE_PATH` definition references `DOTFILES_ZSH_DIR` — update to `DOTFILES_ZSH_PATH`.
- `devops-atuin`: `DEVOPS_ATUIN_CONFIG_DIR` → `DEVOPS_ATUIN_CONFIG_PATH`.
- `devops-k9s`: stale `DEVOPS_K9S_CONF_DIR` → `DEVOPS_K9S_CONF_PATH` (matches code).

## Impact

- **Code**: `zsh/zshrc` (bootstrap L11-15), `zsh/system/core/config/paths.zsh`, `zsh/modules/{notify,yazi,herdr,devops}/`, `zsh/system/nix/`, `zsh/system/nix-darwin/`, `bin/` (10 scripts), `provision/script/` (bootstrap.sh, functions.sh, config/), `tools/antidote/install.sh`, `zsh/modules/git/tests/run.sh`, `zsh/modules/waybar/data/scripts/`.
- **Specs**: new `path-naming-convention`; deltas for `zshrc-load`, `shared-paths`, `core-api`, `devops-atuin`, `devops-k9s`.
- **Docs**: `docs/guides/create-module.md` (herdr row), `docs/guides/implement-tool-in-module.md` (atuin row).
- **User config**: `~/.zshrc` references `DOTFILES_ZSH_DIR`/`DOTFILES_SYSTEM_DIR` must be updated in the same change (precedent: `2026-06-10-refactor-mod-shared-layer`).
- **Risk**: high for core bootstrap vars (consumed across bin scripts and external `~/.zshrc`); mitigated by leaf-first rename order and fallback checks.
