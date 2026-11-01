# Tasks

## 1. Portability fixes

- [x] 1.1 Replace `if [[ -v C_RED ]]; then` with `if [ -n "${C_RED:-}" ]; then` in common/colors.sh:7 and verify the guard still returns 0 on re-source
- [x] 1.2 Replace `if [[ ! -v PACKAGES_COMMON ]]; then` with `if [ -z "${PACKAGES_COMMON:-}" ]; then` in install.sh:135 and verify packages.sh is still sourced when unset
- [x] 1.3 Apply the same replacement as 1.2 in install.sh:232 and verify the Linux branch still sources packages.sh when unset
- [x] 1.4 Replace `${raw,,}` with `$(printf '%s' "$raw" | tr '[:upper:]' '[:lower:]')` in zsh/modules/herdr/tests/hrd_project_exit_codes.bats:70 and verify derive_expected_label still lowercases labels

## 2. Verification

- [x] 2.1 Run shellcheck on common/colors.sh and install.sh and confirm no new errors or warnings
- [x] 2.2 Run the affected bats suite (zsh/modules/herdr/tests/hrd_project_exit_codes.bats) and confirm all tests pass

## 3. Documentation

- [x] 3.1 Document the bash-3.2-portable standard (variable test via ${VAR:-}, no [[ -v ]], no ${var,,}, no associative arrays) in docs/contributing.md and verify the section renders

## Workflow follow-up

- Archive the change after the project review requirements are satisfied.
- Verify the archived result.
