## 1. Scaffold & Entry Point

- [x] 1.1 Create directory structure: `zsh/modules/wezterm/{config,internal,pkg,data}`
- [x] 1.2 Create `plugin.zsh` with idempotent guard `__ZSH_WEZTERM_LOADED`, path var `ZSH_WEZTERM_PATH`, and three-layer source chain

## 2. Config Layer

- [x] 2.1 Create `config/base.zsh` — export `WEZTERM_PACKAGE_NAME`, `WEZTERM_CONFIG_PATH`, `ZSH_WEZTERM_DATA_PATH`
- [x] 2.2 Create `config/main.zsh` — source base + OS dispatch (linux/macOS)
- [x] 2.3 Create `config/osx.zsh` — placeholder (currently unused)
- [x] 2.4 Create `config/linux.zsh` — placeholder (currently unused)

## 3. Internal Layer

- [x] 3.1 Create `internal/base.zsh` — `wezterm::internal::install` (via `core::install wezterm`) and `wezterm::internal::config::sync` (rsync data to config path)
- [x] 3.2 Create `internal/main.zsh` — source base + OS dispatch + ensure rsync + auto-install if wezterm not found
- [x] 3.3 Create `internal/osx.zsh` — placeholder (currently unused)
- [x] 3.4 Create `internal/linux.zsh` — placeholder (currently unused)

## 4. Public Layer (pkg)

- [x] 4.1 Create `pkg/base.zsh` — `wezterm::install`, `wezterm::sync`, `wezterm::post_install`
- [x] 4.2 Create `pkg/main.zsh` — source base + OS dispatch + helper + alias + auto-install
- [x] 4.3 Create `pkg/osx.zsh` — placeholder (currently unused)
- [x] 4.4 Create `pkg/linux.zsh` — placeholder (currently unused)
- [x] 4.5 Create `pkg/helper.zsh` — `wezterm::setup` orchestrator (install if missing, then sync)
- [x] 4.6 Create `pkg/alias.zsh` — `editwezterm` function to open module data in VS Code

## 5. Data & Verification

- [x] 5.1 Populate `data/` directory with wezterm config files from `/run/media/lucho/Jasper/.config/wezterm/` (sync config/, events/, backdrops/, colors/, utils/, wezterm.lua)
- [x] 5.2 Load the module: `source zsh/core/main.zsh && source zsh/modules/wezterm/plugin.zsh`
- [x] 5.3 Verify guard: source twice, loading message appears once
- [x] 5.4 Verify public API: `type wezterm::install`, `type wezterm::sync`, `type wezterm::setup` all return "function"
- [x] 5.5 Verify `editwezterm` alias exists
