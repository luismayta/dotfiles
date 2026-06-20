## Context

The `tx::project` function currently derives project names exclusively from `basename "$PWD"` when no explicit name argument is given. This lacks directory context — two projects in different parent folders but with the same leaf name would produce the same session name. Additionally, names with special characters (`.`, `'`, `;`) produce poor sanitized output.

The function lives in a single file: `zsh/modules/tmux/pkg/helper.zsh` (lines 56-59 for the naming logic).

## Goals / Non-Goals

**Goals:**
- Add parent directory prefix when auto-deriving project names from PWD
- Handle the `$HOME` edge case with `core-` prefix
- Properly sanitize special characters in the full constructed name
- Preserve backward compatibility when `$1` is explicitly provided

**Non-Goals:**
- No changes to tmuxinator integration, template selection, or session attachment logic
- No changes to the `fzf` interactive flow
- No changes to how `tx::project` validates prerequisites

## Decisions

1. **Prefix strategy**: Two-tier logic based on parent directory identity
   - Parent == `$HOME` → prefix `core-` (user's home is the "core" context)
   - Parent != `$HOME` → prefix `{parent_dir}-` (project context)
   - Rationale: Avoids ambiguous short names at the home level while providing meaningful context in deeper structures

2. **Sanitization**: Keep the existing `sed` pipeline but apply it to the full constructed name (not just basename)
   - `sed 's/[^a-zA-Z0-9_-]/_/g; s/__*/_/g; s/^_//; s/_$//'` already handles `.`, `'`, `;` and other special chars
   - Applying it to `{prefix}-{folder}` ensures the combined result is clean
   - Rationale: Single-pass sanitization reduces complexity vs pre-sanitizing parts separately

3. **Minimal diff**: Only modify the name derivation block (currently 3 lines), keeping the rest of the function intact

4. **No new dependencies**: Pure zsh string operations + existing sed usage — no external tools needed beyond what the function already requires

## Risks / Trade-offs

- **[Breaking change]** Users with existing auto-named sessions will see different names → mitigated by the session-exists check (lines 67-75) which offers to attach to existing sessions by old name
- **[Edge case]** `PWD` at filesystem root `/` → parent name is empty; handled by falling back to current behavior
- **[Edge case]** `PWD` equals `$HOME` → `dirname` would be `$HOME`, so parent lookup would need a guard to avoid `$HOME` detection matching itself
