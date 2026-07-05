## 1. Scaffold Module Structure

- [ ] 1.1 Create directory tree: `zsh/modules/herdr/{config,internal,pkg,data}`
- [ ] 1.2 Copy herdr config from `~/Projects/src/github.com/Sin-cy/dotfiles/herdr/.config/herdr/` into `data/` (mirrors structure of `~/.config/herdr/`)

## 2. Entry Point — `plugin.zsh`

- [ ] 2.1 Create `zsh/modules/herdr/plugin.zsh` with idempotent guard (`__ZSH_HERDR_LOADED`), dynamic path (`ZSH_HERDR_PATH`), and 3-layer chain (config → internal → pkg)

## 3. Config Layer

- [ ] 3.1 Create `config/base.zsh` with env vars: `ZSH_HERDR_ENABLED`, `HERDR_PACKAGE_NAME`, `HERDR_INSTALL_URL`, `HERDR_CONFIG_PATH`, `ZSH_HERDR_DATA_PATH`
- [ ] 3.2 Create `config/main.zsh` that sources `base.zsh` with OS dispatch (linux/osx stubs)
- [ ] 3.3 Create `config/linux.zsh` — placeholder
- [ ] 3.4 Create `config/osx.zsh` — placeholder

## 4. Internal Layer — Private Implementation

- [ ] 4.1 Create `internal/base.zsh` with `herdr::internal::install` (primary: curl install script; fallback: brew on macOS) and `herdr::internal::config::sync` (rsync from `ZSH_HERDR_DATA_PATH` to `HERDR_CONFIG_PATH`)
- [ ] 4.2 Create `internal/main.zsh` that sources `base.zsh` with OS dispatch, `core::ensure curl`, and auto-install logic
- [ ] 4.3 Create `internal/linux.zsh` — placeholder
- [ ] 4.4 Create `internal/osx.zsh` — placeholder

## 5. Public Layer — User API

- [ ] 5.1 Create `pkg/base.zsh` with public wrappers: `herdr::install`, `herdr::sync`, `herdr::post_install`
- [ ] 5.2 Create `pkg/main.zsh` that sources layer files with OS dispatch + helper + alias
- [ ] 5.3 Create `pkg/linux.zsh` — placeholder
- [ ] 5.4 Create `pkg/osx.zsh` — placeholder
- [ ] 5.5 Create `pkg/helper.zsh` with `herdr::setup` orchestrator (install if missing → sync → success)
- [ ] 5.6 Create `pkg/alias.zsh` — empty placeholder (guarantees main.zsh can source unconditionally)

## 6. Verify Module

- [ ] 6.1 Load module: `source zsh/core/main.zsh && source zsh/modules/herdr/plugin.zsh` — verify no errors
- [ ] 6.2 Verify guard: sourcing twice shows loading message only once
- [ ] 6.3 Verify public API: `type herdr::install`, `type herdr::setup` return "function"

## 7. Quality Checklist

- [ ] 7.1 All strings use `${HERDR_PACKAGE_NAME}` interpolation (no hardcoded "herdr")
- [ ] 7.2 All output uses `message_*` functions (no `echo`, no `printf`)
- [ ] 7.3 Uses `core::exists` / `core::ensure` (no `which`, no `command -v`)
- [ ] 7.4 No `core::install` reimplementations, no `message_*` reimplementations
