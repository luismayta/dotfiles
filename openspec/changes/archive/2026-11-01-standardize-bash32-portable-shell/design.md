# Design

## Context

See proposal.md - Why. The repo ships bash entry points (install.sh, common/colors.sh)
and bats tests that execute under bash. macOS provides bash 3.2 only, so constructs
requiring bash >= 4.0/4.2 ([[ -v VAR ]], ${var,,}) break bootstrap and tests there.
Zsh files and .direnv/ are out of scope (see proposal).

## Goals / Non-Goals

**Goals:**
- Replace the four identified non-portable constructs with bash-3.2-compatible idioms.
- Document the portable standard in docs/contributing.md.

**Non-Goals:**
- Rewriting other shell constructs (e.g. ${var//a/b}, arrays) that are already 3.2-safe.
- Changing .zsh files or .direnv/.
- Adding new tooling/linting beyond shellcheck.

## Decisions

- [[ -v VAR ]] -> [ -n "${VAR:-}" ]; [[ ! -v VAR ]] -> [ -z "${VAR:-}" ].
  Rationale: ${VAR:-} is defined in bash 3.2 and avoids unbound-variable errors under
  set -u; -n/-z are POSIX test operators.
- ${raw,,} -> $(printf "%s" "$raw" | tr "[:upper:]" "[:lower:]").
  Rationale: tr is universally available and avoids bash 4.0 case modification.
- Document standard in the existing docs/contributing.md under a new subsection of Styleguides,
  rather than a new file, to keep contribution guidance consolidated.

## Risks / Trade-offs

- [Risk] ${VAR:-} treats set-but-empty like unset. -> Acceptable: guards only check presence of
  exported/readonly values; empty is never a valid sentinel here.
- [Risk] tr locale-dependent case folding. -> Mitigation: use [:upper:]/[:lower:] classes.
- [Risk] shellcheck may flag new constructs. -> Run shellcheck on modified files (acceptance #5).

## Migration Plan

No deployment; edits are in-place. Rollback by reverting the four edits.

## Open Questions

None.
