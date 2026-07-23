## Context

The nvim 0.12 migration revealed 7 plugins that are already disabled (`enabled = false`) in the configuration. These plugins represent dead code that:
- Adds maintenance burden
- Creates confusion when navigating plugin files
- Some have built-in alternatives in nvim 0.12

Current state:
- 6 plugin files are entirely disabled
- 1 plugin block (indent-blankline) is disabled within ui.lua
- All disabled plugins have `enabled = false` flag
- No active keymaps or configurations depend on these plugins

## Goals / Non-Goals

**Goals:**
- Remove all disabled plugin files from the codebase
- Remove disabled plugin blocks from composite files (ui.lua)
- Verify nvim 0.12 built-in alternatives work correctly
- Maintain clean plugin directory structure

**Non-Goals:**
- Replacing plugins with built-in alternatives (future task)
- Modifying enabled plugins
- Changing keymaps or configurations
- Updating plugin dependencies

## Decisions

### Decision 1: Delete entire files for disabled plugins

**Choice**: Delete the 6 plugin files entirely rather than keeping them disabled.

**Rationale**: 
- Disabled files serve no purpose
- Reduces file count and cognitive load
- Git history preserves the files if needed later

**Alternatives considered**:
- Keep files with `enabled = false` → Rejected: adds noise
- Move to archive directory → Rejected: unnecessary complexity

### Decision 2: Remove indent-blankline block from ui.lua

**Choice**: Remove the `indent-blankline.nvim` spec block from ui.lua rather than deleting the entire file.

**Rationale**:
- ui.lua contains other active plugins (telescope, which-key, etc.)
- Only the indent-blankline block is disabled
- Preserves the file structure for other plugins

### Decision 3: No keymap changes required

**Choice**: Do not modify any keymaps.

**Rationale**:
- Disabled plugins had no active keymaps
- Built-in alternatives use different keymaps (when implemented later)
- Keeps this change focused on cleanup only

## Risks / Trade-offs

### Risk 1: User accidentally uses removed plugin commands
**Mitigation**: Plugins were already disabled, so no commands were available. Low risk.

### Risk 2: Breaking change for users who manually enable plugins
**Mitigation**: Users can re-add plugins from git history if needed. Document in commit message.

### Risk 3: Missing disabled plugins in scan
**Mitigation**: Comprehensive grep for `enabled = false` completed. All 7 identified.

## Migration Plan

1. Delete 6 plugin files
2. Remove indent-blankline block from ui.lua
3. Run `:checkhealth` to verify no errors
4. Test basic nvim functionality
5. Commit with descriptive message

## Open Questions

None - all decisions are straightforward for this cleanup task.