## Context

`zsh/modules/python` follows the canonical 3-layer module architecture (config/, internal/, pkg/ plus plugin.zsh). Today pyenv is installed via git clone into `~/.pyenv`, lazily loaded, and drives version management through `PYTHON_VERSIONS` / `PYTHON_VERSION_GLOBAL`. uv is already a first-class citizen of the same module via the `PYTHON_UV_ENABLED` toggle (established by archived change `2026-06-28-migrate-pyenv-to-python-module`). Python version pins are duplicated across two sources of truth: `nix/versions.nix` (`pythonVersion = "3.11"`) and `Taskfile.yml` (`PYTHON_VERSION: 3.11.5`). Adjacent pyenv wiring exists in `zsh/zshenv`, `zsh/modules/clean/pkg/base.zsh`, `zsh/modules/starship/data/starship.toml`, and `zsh/system/core/config/env.zsh`. Constraint from Luchex: no file under `openspec/` may be modified by this change's implementation. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Single Python version manager (uv) inside `zsh/modules/python`; all pyenv code paths removed
- Python 3.14 established as the standard global version across module, nix dev-shell, and Taskfile
- Zero pyenv references remaining in active runtime code (`zsh/`, `nix/`, `Taskfile.yml`)

**Non-Goals:**
- Migrating existing `~/.pyenv` interpreters or virtualenvs to uv
- Modifying anything under `openspec/` (existing specs and archived changes stay untouched)
- Changes to starship beyond removing the now-dead `pyenv_version_name` key

## Decisions

- **D1 — uv replaces pyenv mechanics.** Version installation switches to `uv python install`; internal functions previously named `python::internal::pyenv::*` are replaced by uv-equivalent internals. The 3-layer module structure is preserved. Alternative considered: keep both managers behind toggles — rejected; duplication is the problem this change solves.
- **D2 — Remove `PYTHON_PYENV_ENABLED` outright.** No compatibility alias. `PYTHON_UV_ENABLED` remains the sole activation gate for toolchain management. Alternative considered: aliasing the old variable — rejected (YAGNI, consistent with prior archived decisions that pruned unused variables).
- **D3 — Version pins move in lockstep.** `nix/versions.nix` gets `pythonVersion = "3.14"` (with the matching `pkgs.python314` package attribute) and `Taskfile.yml` gets `PYTHON_VERSION: 3.14.<latest patch>`. Assumption recorded: the exact 3.14 patch version is pinned at implementation time to the latest available release; both sources MUST resolve to the same 3.14 minor.
- **D4 — `zsh/zshenv` pyenv block is deleted.** Removes PYENV_ROOT/PATH wiring, `PIPENV_PYTHON`, and `PYENV_VIRTUALENV_DISABLE_PROMPT`. `PIPENV_PYTHON` is dropped rather than remapped (YAGNI; pipenv users can point it at the uv-managed interpreter themselves).
- **D5 — Starship `pyenv_version_name = true` is removed.** Dead configuration once pyenv is gone; starship's uv/python indicators already cover version display.
- **D6 — `cleanup::python::pyenv` is removed** from `zsh/modules/clean/pkg/base.zsh` including its help-text line. It is informative-only today; there is nothing to report once pyenv cannot exist.
- **D7 — `CORE_MESSAGE_PYTHON` message text is rewritten** in `zsh/system/core/config/env.zsh` to instruct users to use the python module / uv, dropping the "install pyenv" wording. Runtime code stays in scope even though specs do not.
- **D8 — Spec drift is accepted and documented.** Live specs (`python-module`, `core-messages`, `cleanup-safety`) will contradict runtime behavior until Luchex explicitly approves archiving this change (which would apply the delta). Until then, openspec/ remains untouched.

## Risks / Trade-offs

- **[Risk] User scripts relying on pyenv shims break** → Mitigation: BREAKING flagged in proposal; changelog entry at implementation; uv provides its own Python discovery and shimming.
- **[Risk] uv-managed CPython builds differ from pyenv builds** (patches, configure flags) → Mitigation: document `uv python install` usage in the module README; per-version interpreters coexist under uv's own layout.
- **[Risk] 3.14 patch availability differs between nixpkgs and uv at implementation time** → Mitigation: pin the exact patch during implementation after checking both channels; fail loudly if they disagree on the minor.
- **[Trade-off] Live OpenSpec specs drift from actual behavior** until archive approval → documented in D8; deliberate scope directive, revisited only by explicit Luchex decision.

## Migration Plan

Implementation order within the change branch: (1) module core swap, (2) adjacent runtime wiring removal, (3) version pin sync, (4) verification sweep. Rollback strategy: single-branch change; `git revert` restores pyenv behavior wholesale. No data migration is attempted for existing `~/.pyenv` installations.

## Open Questions

None blocking. The exact 3.14 patch number is deliberately deferred to implementation (D3) and does not affect specs, approach, or task breakdown.
