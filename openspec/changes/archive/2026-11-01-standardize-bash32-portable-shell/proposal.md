# Proposal

## Why

On macOS the system bash is 3.2, but several repo shell scripts use bash >= 4.0 constructs
(`[[ -v VAR ]]`, `${var,,}`), which break the bootstrap and the affected bats tests on
macOS/older bash. Standardize these to portable bash-3.2-compatible idioms so bootstrap works
everywhere.

## What Changes

- Replace `if [[ -v C_RED ]]; then` with `if [ -n "${C_RED:-}" ]; then` in `common/colors.sh:7`.
- Replace `if [[ ! -v PACKAGES_COMMON ]]; then` with `if [ -z "${PACKAGES_COMMON:-}" ]; then` in `install.sh:135` and `install.sh:232`.
- Replace `${raw,,}` with `$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')` in `zsh/modules/herdr/tests/hrd_project_exit_codes.bats:70`.
- Document the bash-3.2-portable standard (variable test via `${VAR:-}`, no `[[ -v ]]`,
  no `${var,,}`, no associative arrays) in `docs/contributing.md`.

## Capabilities

### New Capabilities

<!-- None: pure portability refactor, no behavior change. skip_specs: true. -->

### Modified Capabilities

<!-- None. -->

## Impact

Affected code: `common/colors.sh`, `install.sh`, `zsh/modules/herdr/tests/hrd_project_exit_codes.bats`,
and `docs/contributing.md`. No API or dependency changes. No `.zsh` or `.direnv/` files touched.
