## Context

The file `zsh/modules/tmux/data/sync/tmux/linux.conf` provides Linux-specific tmux configuration including clipboard integration. The current implementation uses a deeply nested `if-shell` chain (3 levels) to detect clipboard tools in priority order: `pbcopy` → `xclip` → `wl-copy`.

The nesting creates fragile quoting at each level. On line 22, the final fallback `'display-message \"No clipboard tool (pbcopy/xclip/wl-copy) found\"'"` contains escaped double quotes inside single quotes, which tmux's argument parser interprets as multiple arguments instead of a single command string, producing a "too many arguments" error.

## Goals / Non-Goals

**Goals:**
- Fix the "too many arguments" error on the `display-message` fallback path
- Maintain identical behavior for the three clipboard tools (pbcopy → xclip → wl-copy priority)
- Preserve the single-file approach (no new external scripts or dependencies)

**Non-Goals:**
- No change to Darwin/macOS clipboard configuration
- No change to tmux key bindings or copy-mode behavior
- No addition of new clipboard tools beyond the current three
- No restructuring of tmux config file organization

## Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| **Replace nested `if-shell` quoting with curly brace `{}` syntax** | Tmux's command parser supports `{}` for grouping commands. Each branch becomes a clean block — no escaped quotes, no nesting issues. Documented in tmux Advanced Use wiki. | (1) `run-shell` + `set -g @clipboard-cmd` — async, introduces timing window; (2) External script file — adds file dependency; (3) Inline `if-shell` with corrected quoting — fragile, same root cause |
| **Use `if-shell` (synchronous, blocking)** | `if-shell` blocks the command queue during config load until the shell command finishes. Each bind-key is set before the next runs. From tmux docs: *"if-shell... stop execution of subsequent commands on the queue until shell command finishes."* | `run-shell -b` (background) — race condition; `%if` directive — only checks formats, not shell commands |
| **Each branch sets the same `bind-key` (overwrite pattern)** | Only the matching branch's bind-key survives. Simple, no indirection. The `display-message` fallback on line 22 works directly — no variable needed. | Setting a user option + reading it with `#{@clipboard-cmd}` — adds complexity, tmux 3.2+ |

**Approach outline (curly brace `if-shell`):**

```tmux
if-shell "command -v pbcopy >/dev/null 2>&1" {
    bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel pbcopy
} {
    if-shell "command -v xclip >/dev/null 2>&1" {
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -selection clipboard -in"
    } {
        if-shell "command -v wl-copy >/dev/null 2>&1" {
            bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel wl-copy
        } {
            bind-key -T copy-mode-vi y display-message "No clipboard tool found"
        }
    }
}
```

Each `{}` block is parsed by tmux as a single command argument. No shell quoting conflicts. Each `if-shell` runs synchronously during config load.

---

## macOS (osx.conf) — Modernization

### Current state analysis (tmux 3.5a on macOS 14+)

| Line | Current | Issue |
|------|---------|-------|
| 3-5 | `set -g mode-keys vi` + `setw -g mode-keys vi` | Redundant — already set in `.tmux.conf` (line 100) |
| 8 | `set -g set-clipboard off` | Blocks OSC 52. Default is `external` in tmux 3.5a |
| 11 | `set-option -g default-command "exec reattach-to-user-namespace -l $SHELL"` | Forces login shell wrapper on ALL panes. `reattach-to-user-namespace` was a workaround for macOS < 10.14 |
| 14-15 | `@copy_cmd`/`@paste_cmd` using `reattach-to-user-namespace` | Wrapper not needed on modern macOS, but harmless as a safety net |

### Changes

1. **Remove** `set -g mode-keys vi` and `setw -g mode-keys vi` (redundant)
2. **Change** `set -g set-clipboard off` → `set -g set-clipboard external` (allow OSC 52)
3. **Remove** `set-option -g default-command "exec reattach-to-user-namespace -l $SHELL"` (no longer needed)
4. **Keep** `reattach-to-user-namespace` in `@copy_cmd`/`@paste_cmd` as optional safety net (backward compatible)

---

## Main config (.tmux.conf) — Consistency

The OS-specific source lines (107-108) use the old string-quoting style:

```tmux
if-shell 'uname | grep -q Darwin' "source-file ~/.config/tmux/osx.conf"
if-shell 'uname | grep -q Linux' "source-file ~/.config/tmux/linux.conf"
```

**Change** to curly brace syntax for consistency with the linux.conf fix:

```tmux
if-shell 'uname | grep -q Darwin' {
    source-file ~/.config/tmux/osx.conf
}
if-shell 'uname | grep -q Linux' {
    source-file ~/.config/tmux/linux.conf
}
```

## Risks / Trade-offs

- **tmux version**: Curly brace syntax requires tmux 1.8+ (stable since 2013). The config already uses `copy-mode-vi` which requires 2.1+. **No compatibility issue.**
- **`if-shell` blocks during load**: Three sequential shell forks during config load adds ~10-30ms. Negligible. `run-shell` would have the same cost.
- **No visual feedback if no tool**: The `display-message` fallback provides clear user feedback when no clipboard tool is found.
- **macOS `set-clipboard external`**: Changes from fully blocking OSC 52 to allowing it. If a terminal emulator doesn't support OSC 52, behavior is unchanged. tmux-yank plugin may also set clipboard — `set-clipboard external` is the recommended setting since tmux 2.6.