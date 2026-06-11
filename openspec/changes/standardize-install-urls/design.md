## Context

Currently, 8 of 10 zsh modules that perform tool installations embed URLs directly in their `internal/` implementation scripts. The `ai` module demonstrates a cleaner pattern: `AI_INSTALL_URL_*` variables declared in `config/base.zsh` and consumed in `internal/base.zsh`. The `goenv` module partially follows this with `GOBREW_DOWNLOAD_URL`. This design standardizes the pattern across all modules.

## Goals / Non-Goals

**Goals:**
- Define and document the `<MODULE>_INSTALL_URL_<TOOL>` convention
- Migrate all hardcoded install URLs from `internal/` to `config/` files
- Maintain identical behavior — no URL changes, no logic changes
- Ensure each module is independently verifiable

**Non-Goals:**
- Changing installation methods (e.g., git clone → curl | sh, or vice versa)
- Refactoring installation logic beyond URL extraction
- Adding new tools or URLs
- Changing module loading or initialization order

## Decisions

### Decision 1: Naming convention `<MODULE>_INSTALL_URL_<TOOL>`
- **Choice**: `<UPPER_MODULE_NAME>_INSTALL_URL_<UPPER_TOOL_NAME>`, e.g., `FNM_INSTALL_URL`, `RUST_INSTALL_URL_RUSTUP`
- **Rationale**: Consistent with existing `AI_INSTALL_URL_*` pattern. Upper snake case matches project conventions. Tool qualifier allows modules that install multiple tools (rust, rvm) to have distinct URL variables.
- **Alternative considered**: `_INSTALL_<TOOL>_URL` — rejected for inconsistency with existing patterns.

### Decision 2: URL variables go in `config/base.zsh`
- **Choice**: Place URL variables in the module's `config/base.zsh` file, with OS-specific overrides in `config/osx.zsh` / `config/linux.zsh` where applicable.
- **Rationale**: `config/` files are sourced before `internal/` files and are the established location for configuration variables. Matches the `ai` module pattern.
- **Alternative considered**: A shared `config/urls.zsh` file — rejected for consistency (each module owns its config).

### Decision 3: Internal files reference the variable directly
- **Choice**: Replace hardcoded strings in `internal/base.zsh` with `${MODULE_INSTALL_URL_TOOL}` references.
- **Rationale**: Zero behavioral change. The variable expands to the same URL at runtime.
- **Alternative considered**: Wrapping in a helper function — adds unnecessary indirection for static URLs.

### Decision 4: One commit per module
- **Choice**: Each module gets its own commit with a `chore (scope):` message.
- **Rationale**: Keeps changes atomic and independently revertible. Follows project commit conventions.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| OS-specific URL overrides needed later | Convention supports `config/osx.zsh`/`config/linux.zsh` overrides by design |
| Variable naming conflicts between modules | `MODULE_` prefix namespaces each variable — no conflicts possible |
| Missed hardcoded URL in non-standard internal file | All zsh modules will be verified with grep post-migration |
| Forgetting to `export` the variable | Config files already export all variables — verified by convention |