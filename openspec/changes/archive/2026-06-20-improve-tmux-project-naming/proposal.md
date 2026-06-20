## Why

The `tx::project` function in the tmux module generates project names by taking `basename "$PWD"` and sanitizing it. This produces names that lack context when multiple projects share the same leaf directory name, or when the directory contains special characters (`.`, `'`, `;`) that result in confusing sanitized names like `_name`. Better naming rules will make tmux sessions easier to identify and manage.

## What Changes

- Modify `tx::project` in `zsh/modules/tmux/pkg/helper.zsh` to derive project names using parent directory context
- When no explicit project name is given (`$1`):
  - If the parent directory is the user's home (`$HOME`), prefix with `core-`: `core-{folder}`
  - Otherwise, prefix with the parent directory name: `{parent}-{folder}`
- Improve special character replacement for `.`, `'`, `;` and other non-alphanumeric characters in the sanitization logic
- When `$1` is explicitly provided, preserve the current behavior (sanitize as-is)

## Capabilities

### New Capabilities
- `smart-project-naming`: Derive contextual tmux session names from the directory hierarchy, with proper handling of home directory and special characters

### Modified Capabilities
<!-- No existing specs are affected -->

## Impact

- **Single file change**: `zsh/modules/tmux/pkg/helper.zsh` — lines 56-59 of `tx::project`
- No new dependencies
- Backward compatible: explicit `$1` argument behavior unchanged
- Session names will change when no argument is passed (users relying on auto-named sessions will see new names)
