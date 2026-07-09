## 1. Domain separation: create domain files

- [x] 1.1 Create `internal/install.zsh` — move `install`, `config::sync` + plugin functions from `base.zsh`
- [x] 1.2 Create `internal/workspace.zsh` — move workspace CRUD functions from `base.zsh`
- [x] 1.3 Create `internal/worktree.zsh` — move all `worktree::*` functions from `base.zsh`
- [x] 1.4 Strip `internal/base.zsh` to only utilities: `fzf_select`, `derive_project_name`, `list_templates`, `select_template`, `resolve_workspace_id`

## 2. Domain separation: update sourcing

- [x] 2.1 Update `internal/main.zsh` — add `source` lines for new files in dependency order (base → install → workspace → worktree → pane)
- [x] 2.2 Run `exec zsh` and verify no sourcing errors (all functions load)

## 3. Pane layout: internal helper

- [x] 3.1 Add `hrd::internal::pane::setup_3_pane_layout` function to `internal/pane.zsh` — accepts `ws_id`, splits panes (right 60%, down 50%), renames to `editor`/`shell`/`agent`, handles missing ID with warning, returns 1 on failure with warning

## 4. Pane layout: refactor hrd::project

- [x] 4.1 Replace inline pane commands (lines 114-123) in `helper.zsh` `hrd::project` with call to `hrd::internal::pane::setup_3_pane_layout "$ws_id"`

## 5. Pane layout: wire hrdw::create

- [x] 5.1 In `helper.zsh` `hrdw::create`, after `hrd::internal::worktree::create "$name" "$label"` succeeds, resolve ws_id via `hrd::internal::resolve_workspace_id "$label"` and call `hrd::internal::pane::setup_3_pane_layout "$ws_id"` with warning on failure

## 6. Verification

- [x] 6.1 Run `shellcheck` on all modified files — zero new warnings
- [x] 6.2 Recargar dotfiles (verificado: sourcing correcto en test zsh, funciones disponibles)
