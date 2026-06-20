## 1. Extract pure functions (no I/O)

- [x] 1.1 Create `zsh/modules/tmux/internal/project-name.zsh` with `tx::internal::derive_project_name`
- [x] 1.2 Create `zsh/modules/tmux/internal/preview-command.zsh` with `tx::internal::preview_command`
- [x] 1.3 Create `zsh/modules/tmux/internal/list-templates.zsh` with `tx::internal::list_templates`

## 2. Extract composed functions (I/O + interaction)

- [x] 2.1 Create `zsh/modules/tmux/internal/select-template.zsh` composing `list_templates` + `preview_command` + fzf
- [x] 2.2 Create `zsh/modules/tmux/internal/attach-or-continue.zsh` with `tx::internal::attach_if_exists`

## 3. Rewrite orchestrator

- [x] 3.1 Replace `tx::project` body in `zsh/modules/tmux/pkg/helper.zsh` to call internal functions
- [x] 3.2 Add source lines for new internal files in `zsh/modules/tmux/plugin.zsh`

## 4. Verify

- [x] 4.1 Source the module and run `tx::project` with explicit name
- [x] 4.2 Source the module and run `tx::project` without argument in various directories
