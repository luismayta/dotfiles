## Context

The `tools/` directory contains 6 installer scripts. Investigation of the call chain reveals:

- `install.sh` → `setup::factory()` → `source provision/script/run.sh` → `bootstrap.sh` → `functions.sh:initialize()` → `dotfiles_install_apps()` → iterates `${APPS[@]}` → calls `"${TOOLS_DIR}/${app}/install.sh"`
- Only 3 of the 6 tools are in `APPS=(git-extras fonts antidote)` (defined in `provision/script/config/base.sh`)
- The other 3 (`antibody`, `brew`, `wakatime`) are dead code

The 3 active installers are simple scripts (15-32 lines each) that:
- Lack `set -euo pipefail`
- Use `exit` without exit codes
- Use no `trap` for error handling
- Reference unqualified variables shared from bootstrap.sh context

## Goals / Non-Goals

**Goals:**
- Remove 3 dead tool installer directories from `tools/`
- Harden the 3 active tool installer scripts with the same strict-mode pattern used in `install.sh` and `provision/script/*`

**Non-Goals:**
- Refactoring the tool invocation mechanism (`APPS` loop in `functions.sh`)
- Adding new tools to the `APPS` array
- Changing how tools are structured or invoked

## Decisions

1. **Simple deletion over deprecation warnings** — All 3 dead tools have zero callers. No migration needed since they were never invoked. A deprecation notice would be noise with no audience.

2. **Consistent hardening pattern** — Following the established pattern from `install.sh` (the most recently hardened bootstrap script):
   - `set -euo pipefail` at top
   - `trap '...' ERR` for error reporting
   - `readonly` for constants/static strings
   - `local` for all function-scoped variables
   - `exit 1` instead of bare `exit`

3. **Minimal behavioral changes** — Hardening SHOULD NOT change the installation behavior. Only add safety guarantees. The exception is fixing the `wakatime` undefined variables (but wakatime is being removed, not fixed).

## Risks / Trade-offs

- **Missing SCRIPT_DIR in curl|bash context** — `SCRIPT_DIR` is set by `bootstrap.sh` (`${PATH_REPO}/provision/script`). If for some reason `bootstrap.sh` hasn't been sourced before the tool installer runs, `${SCRIPT_DIR}` would be empty. Mitigation: the active installers already guard with `[ -r "${SCRIPT_DIR}/bootstrap.sh" ] && source ...`, and in normal flow `bootstrap.sh` is always sourced first by `run.sh`. No change needed.
- **Minimal testing surface** — These scripts are only invoked during initial dotfiles provisioning. They are hard to unit-test. Mitigation: `bash -n` syntax check already enforced via pre-commit hooks.
