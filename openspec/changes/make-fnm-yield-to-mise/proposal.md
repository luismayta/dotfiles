# Proposal

## Why

Node version drift: the mise-managed project repository pins `node = "24.20.0"` in `mise.toml:8` (with `mise.lock`), but interactive shells resolve `node` to v24.11.1 via fnm — because this repository's zsh configuration activates fnm unconditionally.

Mechanism (verified; the `mise.toml`, `.envrc`, and `mise-check-versions` `Taskfile.yml` references below are files of the mise-managed project repository where the drift was observed — the fnm activation points are in this dotfiles repository):

1. direnv runs `.envrc:4-7`, which prepends `$HOME/.local/share/mise/shims` to PATH.
2. On every `cd`, `chpwd_functions` order is: `_direnv_hook` → ... → `_fnm_autoload_hook` (re-prepends `/run/user/1000/fnm_multishells/<id>/bin` OVER the mise shims) → ... → `_mise_hook_chpwd`.
3. fnm multishell points to the fnm default alias `~/.local/share/fnm/aliases/default` → v24.11.1.
4. `task mise-check-versions` (`Taskfile.yml:302-337`) does NOT catch this because it runs assertions inside `mise exec`, which rebuilds PATH itself — it never sees interactive-shell shadowing.

fnm activation points (unconditional, no mise awareness):

- `zsh/modules/nodejs/internal/base.zsh:11-17` — `nodejs::internal::fnm::load`: prepends `FNM_PATH`, runs BOTH `eval "$(fnm env)"` and `eval "$(fnm env --use-on-cd --shell zsh)"` (the latter registers `_fnm_autoload_hook`).
- `zsh/modules/nodejs/internal/main.zsh:22` — calls the loader; `:25` auto-installs fnm if missing.
- `zsh/modules/nodejs/config/base.zsh:4-6` — hardcoded `NODEJS_VERSIONS=(24.11.1)`; `:12` `NODEJS_VERSION_GLOBAL=24.11.1`.
- `~/.zshrc:121-127` — DUPLICATE inline fnm block (regular file, NOT a symlink, NOT in the repository — outside git control).
- `zsh/modules/devops/internal/mise.zsh:4-11` — `mise activate zsh`; `:49-51` load + factory at source time.

## What Changes

- Make fnm activation conditional: when mise manages the directory (mise.toml / .mise.toml / .tool-versions present, or mise already active), fnm skips its PATH prepend and `_fnm_autoload_hook` must not re-prepend the fnm multishell over the mise shims — mise shims win the PATH.
- Guard `_fnm_autoload_hook` so the yield decision is re-evaluated on every `cd`, not only at shell start.
- Remove or guard the duplicate inline fnm block in `~/.zshrc:121-127` (manual step — the file is a regular untracked file outside git control).
- Align `zsh/modules/nodejs/config/base.zsh` node version pins (`NODEJS_VERSIONS`, `NODEJS_VERSION_GLOBAL`) from `24.11.1` to `24.20.0`, matching `mise.toml:8`.
- Harden `mise-check-versions` (`Taskfile.yml:302-337`) with an interactive PATH-shadowing assertion that runs outside `mise exec`.
- No behavior change for directories without mise config; fnm remains available globally for projects that do not use mise.

## Capabilities

### New Capabilities

- `fnm-yields-to-mise`: fnm activation and its `--use-on-cd` hook yield to mise in mise-managed directories — mise shims keep PATH precedence and fnm does not re-prepend over them; fnm stays fully active in directories without mise config.

### Modified Capabilities

- `nodejs-module`: FNM PATH setup and `--use-on-cd` hook registration become conditional on mise not managing the directory; `NODEJS_VERSIONS` / `NODEJS_VERSION_GLOBAL` align to the mise pin (24.20.0).

## Impact

- Files touched are all inside the dotfiles repo EXCEPT `~/.zshrc` (untracked, manual step).
- The `mise-check-versions` hardening (task 4) targets `Taskfile.yml:302-337` in the mise-managed project repository, outside this repository.
- No behavior change for directories without mise config.
- Related precedent: archived change `2026-11-22-add-mise-devops` (PE-661).
