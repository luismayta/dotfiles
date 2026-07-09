## Context

The `hrdw::remove` command (and `hrdw::open`) use an interactive fzf selector powered by `hrd::internal::worktree::fzf_select`. This function lists worktrees in the format `"branch | path"` and pipes them through `hrd::internal::fzf_select` with a preview command.

### Root Cause

The worktree list output uses the format `"branch | path"` (defined in `hrd::internal::worktree::list` at line 35 of `internal/worktree.zsh`). For example:

```
feature/RD-21 | /home/user/project/.herdr/worktrees/feature/RD-21
```

fzf's `--preview` supports field indexing with `{n}` notation, which splits the input line by **whitespace** by default (not by `|`). Therefore:

| Index | Value |
|-------|-------|
| `{1}` | `feature/RD-21` |
| `{2}` | `\|` (pipe) |
| `{3}` | `/home/user/project/.herdr/worktrees/feature/RD-21` |

The current preview command at line 137 reads `echo {2} \| xargs ls -la`, which resolves `{2}` to the pipe character — producing no useful output in the preview pane.

### Current call chain

```
hrdw::remove
  → hrd::internal::worktree::fzf_select "Remove worktree: "
    → hrd::internal::fzf_select "$prompt" "echo {2} | xargs ls -la"
      → fzf --preview "echo {2} | xargs ls -la" --preview-window=right:60%
```

## Goals / Non-Goals

**Goals:**
- Fix the fzf preview to display the worktree directory contents when selecting a worktree
- Minimize blast radius — only the field index changes, nothing else in the flow

**Non-Goals:**
- Changing the worktree list format (would require updating all downstream awk parsers in `pkg/helper.zsh`)
- Adding new dependencies (e.g., `tree`, `eza`) to the preview
- Changing `hrd::internal::fzf_select` signature or behavior

## Decisions

**Decision: Change field index from `{2}` to `{3}` in the preview command**

Rationale:
- Minimal change (one character in one file)
- `{3}` correctly maps to the path field in fzf's whitespace-based indexing
- The downstream parsers already use `awk -F ' \\\\| '` which correctly handles the pipe delimiter — they are unaffected
- Alternative: adding `--delimiter=" | "` to fzf would require modifying `hrd::internal::fzf_select` and would affect all fzf callers. Overkill for this fix.

**Decision: Simplify the preview command from `echo {3} | xargs ls -la` to `ls -la {3}`**

Rationale:
- The `echo | xargs` wrapper is unnecessary indirection when `ls -la` can take the path directly
- No whitespace-splitting concerns since the path is a single field

Alternative considered: Using `{3..}` for paths with spaces. Rejected because: (a) git worktree paths rarely contain spaces, (b) `{3..}` would break if the path had fewer fields than expected, (c) `ls -la` on multiple arguments would still work but produce less readable output.

## Risks / Trade-offs

- **[Low] Existing grep/awk parsers** → The downstream branch/path extraction in `pkg/helper.zsh` uses `awk -F ' \\\\| '` which operates on the full line, not fzf fields. Untouched.
- **[Low] Other callers of `fzf_select`** → The `select_template` function passes `bat ... $template_dir/{}.toml` where `{}` is the whole line (not field-indexed). Unaffected.
- **[Low] Paths with spaces** → If a worktree path contains spaces, `{3}` would only capture the first segment. Mitigation: git worktree paths are machine-generated from branch names, which are typically slugified.
