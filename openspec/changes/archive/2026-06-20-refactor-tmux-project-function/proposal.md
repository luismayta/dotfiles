## Why

The `tx::project` function in `zsh/modules/tmux/pkg/helper.zsh` has 9 distinct responsibilities crammed into 85 lines — dependency validation, template listing, fzf preview construction, interactive selection, name derivation, sanitization, session collision handling, and process launching. This high coupling makes the function hard to test, maintain, and extend. Extracting focused internal functions will improve readability, enable unit testing, and make future changes safer.

## What Changes

- Extract `tx::internal::list_templates` — discovers `.yml` template files
- Extract `tx::internal::preview_command` — builds the fzf preview command string
- Extract `tx::internal::select_template` — composes listing + preview + fzf picker
- Extract `tx::internal::derive_project_name` — derives and sanitizes the project name from argument or directory context
- Extract `tx::internal::attach_if_exists` — checks for existing tmux session and prompts to attach
- Rewrite `tx::project` as a thin orchestrator that calls the internal functions in sequence
- Move internal functions to `zsh/modules/tmux/internal/` following the module's existing convention
- **No breaking changes**: public API (`tx::project`) and behavior remain identical

## Capabilities

### New Capabilities
- `template-selection`: Discover, preview, and interactively select a tmuxinator template
- `project-name-derivation`: Derive a tmux-safe project name from argument or directory hierarchy
- `session-collision-handler`: Detect existing tmux sessions and offer to attach

### Modified Capabilities
<!-- No existing specs are affected — this is purely an internal refactor -->

## Impact

- **Files created**: 4 new files under `zsh/modules/tmux/internal/`
- **Files modified**: `zsh/modules/tmux/pkg/helper.zsh` (orchestrator rewrite), `zsh/modules/tmux/plugin.zsh` (add source lines)
- **Zero behavioral change**: All public functions keep identical signatures and behavior
- **No new dependencies**
