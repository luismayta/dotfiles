## Context

The `ai` module (`zsh/modules/ai/`) currently has a monolithic `internal/base.zsh` (637 lines, 37 functions) that contains all tool installation, PATH loading, config sync, and domain-specific logic for 10+ tools. The `pkg/helper.zsh` (178 lines, 35 functions) similarly bundles all public API wrappers in one file.

The `herdr` module already demonstrates the correct pattern: domain-specific files (`workspace.zsh`, `worktree.zsh`, `pane.zsh`, `install.zsh`) sourced from `internal/main.zsh` in dependency order. This refactor aligns the `ai` module with that convention.

## Goals / Non-Goals

**Goals:**
- Split `internal/base.zsh` into domain-specific files under `internal/`
- Split `pkg/helper.zsh` into domain-specific files under `pkg/`
- Remove `internal/helper.zsh` (content migrates to domain files)
- Maintain identical public API (all function names and signatures unchanged)
- Follow the herdr module's naming and sourcing conventions exactly

**Non-Goals:**
- Changing any function behavior or signatures
- Modifying `config/`, `data/`, or `plugin.zsh`
- Adding new tools or functionality
- Changing the module's env var naming or structure

## Decisions

### 1. Domain file granularity

**Decision**: Split into 7 domain files per layer (internal + pkg).

**Rationale**: Group by logical tool family, not by individual tool. Simple tools with only 1-2 functions (shimmy, hf, openclaw, codegraph, tmuxai) share a `tools.zsh` file. Complex tools with 4+ functions get their own file (opencode, fabric, ollama, skills, openspec, graphify, hunk).

**Alternative considered**: One file per tool (12+ files). Rejected — too granular for tools with only 1 function.

**Files created per layer:**

| File | Functions (internal) | Functions (pkg) | Content |
|------|---------------------|-----------------|---------|
| `opencode.zsh` | 4 | 3 + editopencode | Install, sync, load |
| `fabric.zsh` | 3 | 3 | Install, pattern sync/pull |
| `ollama.zsh` | 3 | 4 | Models list/pull/install |
| `skills.zsh` | 11 | 8 | CLI install, add/use/list/update/search/publish/setup |
| `openspec.zsh` | 7 | 5 | Install, upgrade, register, init, update, setup |
| `graphify.zsh` | 4 | 4 | Install, upgrade, register skill, setup |
| `hunk.zsh` | — | 5 | Review, show, daemon, config sync |
| `tools.zsh` | 12 | 5 | Batch install + shimmy/hf/openclaw/codegraph/tmuxai/rtk/pi wrappers |

### 2. Source order in main.zsh

**Decision**: Source domain files in `internal/main.zsh` from most fundamental to most dependent.

**Rationale**: `tools.zsh` must load first (PATH loaders for all tools), then domain files that may depend on those PATHs.

**Order**:
```
internal/main.zsh:
  1. base.zsh          (shared utilities — ai::internal::packages::install)
  2. tools.zsh         (batch install, PATH loaders, simple tool installs)
  3. opencode.zsh
  4. fabric.zsh
  5. ollama.zsh
  6. skills.zsh
  7. openspec.zsh
  8. graphify.zsh
  9. hunk.zsh
  10. OS dispatch (osx.zsh / linux.zsh)
```

**pkg/main.zsh**:
```
  1. base.zsh
  2. opencode.zsh
  3. fabric.zsh
  4. ollama.zsh
  5. skills.zsh
  6. openspec.zsh
  7. graphify.zsh
  8. hunk.zsh
  9. tools.zsh
  10. OS dispatch (osx.zsh / linux.zsh)
  11. alias.zsh
```

### 3. Remove internal/helper.zsh

**Decision**: Delete `internal/helper.zsh` entirely. Its 5 functions migrate to `fabric.zsh` (2 functions) and `ollama.zsh` (3 functions).

**Rationale**: `helper.zsh` is a leftover catch-all. Domain files are the correct home.

## Risks / Trade-offs

- **[Risk] Circular dependencies between domain files** → Mitigation: Domain files must not source each other. All cross-domain calls go through the public API or are handled in `base.zsh`. Verified by reviewing function call graph — no domain file calls functions from another domain file.
- **[Risk] Missing functions during split** → Mitigation: After split, verify every function from the original `internal/base.zsh` and `pkg/helper.zsh` exists exactly once across the new domain files. Use `grep -r "::" zsh/modules/ai/internal/ zsh/modules/ai/pkg/` to audit.
- **[Trade-off] More files to navigate** → Accepted. 14 small files (avg ~45 lines each) are easier to reason about than 2 monolithic files (637 + 178 lines).
