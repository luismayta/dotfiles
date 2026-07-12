## Context

The `zsh/modules/fnm/` module manages the full Node.js toolchain: installing FNM (Fast Node Manager), setting up Node.js versions via `fnm`, and installing npm packages. Despite this broader scope, the module namespace (`fnm::*`), variable scope (`ZSH_FNM_*`), and directory name (`fnm/`) all reference only the underlying tool — not the language ecosystem it manages. All sibling modules (`python`, `rust`, `goenv`, `rvm`) use language-level names.

The module follows the standard `zsh/modules/<>` convention:
- `plugin.zsh` → sources `config/main.zsh`, `internal/main.zsh`, `pkg/main.zsh`
- Auto-discovered by `zshrc` via `for __module_dir in "${DOTFILES_ZSH_DIR}"/modules/*(/N)`
- No hardcoded registration required for loading

## Goals / Non-Goals

**Goals:**
- Rename module directory `fnm/` → `nodejs/` with git history preserved (`git mv`)
- Rename all internal scope identifiers: `ZSH_FNM_*` → `ZSH_NODEJS_*`
- Rename all function names: `fnm::*` → `nodejs::*`
- Rename module config variables: `FNM_PACKAGE_NAME` → `NODEJS_TOOL_NAME`, `FNM_VERSION_GLOBAL` → `NODEJS_VERSION_GLOBAL`, `FNM_PACKAGES` → `NODEJS_PACKAGES`
- Update `.goji.json` scope from `fnm` to `nodejs`
- Update `DOTFILES_SETUP_MODULES` to include `nodejs`
- Update `openspec/specs/fnm-module/` → `openspec/specs/nodejs-module/`

**Non-Goals:**
- Changing any behavior, logic flow, or shell semantics
- Renaming the actual external tool commands (`fnm install`, `fnm env`, `fnm use`, `fnm alias`)
- Renaming external tool variables (`FNM_PATH`, `FNM_VERSION`, `FNM_INSTALL_URL`)
- Adding new features or capabilities to the module

## Decisions

### Decision 1: Preserve external tool references as-is
The module implements functions that invoke the `fnm` binary directly (e.g., `fnm install`, `fnm env`). These are external CLI commands, not module-internal identifiers, and must remain unchanged.

**Rationale:** `fnm` is still the underlying tool. Changing CLI invocations would break functionality. The module manages `nodejs` *through* `fnm`.

### Decision 2: Rename config vars that describe module behavior, keep those describing external tool
- Rename: `FNM_PACKAGE_NAME` → `NODEJS_TOOL_NAME` (it's a configurable tool name, not necessarily fnm)
- Rename: `FNM_VERSION_GLOBAL` → `NODEJS_VERSION_GLOBAL` (it's the Node.js version to use globally)
- Rename: `FNM_PACKAGES` → `NODEJS_PACKAGES` (it's the list of npm packages)
- Keep: `FNM_PATH` (path to the fnm binary)
- Keep: `FNM_VERSION` (version of the fnm binary)
- Keep: `FNM_INSTALL_URL` (URL to download fnm)

**Rationale:** Clear distinction between "config about the module's domain" (nodejs) vs. "config about the underlying tool" (fnm). Prevents confusion.

### Decision 3: Git mv directory to preserve history
Use `git mv zsh/modules/fnm zsh/modules/nodejs` to maintain git blame continuity.

**Rationale:** Important for future auditing. A simple `mkdir` + copy would lose history.

### Decision 4: No backward-compat aliases
No `fnm::*` → `nodejs::*` wrapper functions or `ZSH_FNM_*` → `ZSH_NODEJS_*` fallback variables will be created.

**Rationale:** No external consumers reference these names. Zero migration cost.

## Risks / Trade-offs

- **Hidden fnm references in comments**: README-style comments or docstrings may mention "fnm" as the tool name. Some of these should stay (tool name), others should change (module name). Each needs judgment.
- **Setup registration gap**: `DOTFILES_SETUP_MODULES` currently doesn't include `fnm/nodejs`. This was a pre-existing omission. The rename is a natural time to add it, but must be verified (is there a `nodejs::setup` function?).
- **Disabled modules**: Any user with `ZSH_DISABLED_MODULES="fnm"` in `.customrc` must update to `ZSH_DISABLED_MODULES="nodejs"`. This is a **BREAKING** change for those users.
- **Git blame interruption**: Single large rename commit will temporarily break git blame for module files.

## Open Questions

- (none — all decisions are settled by the research above)
