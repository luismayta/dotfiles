---
id: "DOCS-ADR-001-ZSH-MODULE-LIFECYCLE-CLASSIFICATION-8B9433"
title: "Classify zsh modules as ARCHIVE, DISABLE, or KEEP under criteria C1–C6"
description: "Lifecycle policy for the 40 modules under zsh/modules/, classified against criteria C1–C6 with precedence rules, applied through existing enable/disable mechanisms only."
type: "decision"
status: "draft"
company: "codip"
project: "dotfiles"
version: "1.0.0"
author: "Lucho"
created: "2026-11-26"
updated: "2026-11-26"
tags: ["zsh", "lifecycle", "nix", "mise", "architecture"]
sources: ["openspec/changes/review-zsh-modules-lifecycle/design.md", ".codi/jira/PE-699/requirements/PE-699.md", ".codi/jira/PE-699/adr/001-zsh-module-lifecycle-classification.md (origin, PE-699)"]
related: []
---

# ADR-001: Classify zsh modules as ARCHIVE, DISABLE, or KEEP under criteria C1–C6

**Status:** Proposed

**Date:** 2026-11-26

**Author:** Lucho

**Promotion note:** 2026-11-26 — promoted from `.codi/jira/PE-699/adr/001-zsh-module-lifecycle-classification.md` (issue-scoped, PE-699) to the canonical transversal home `docs/adr/`; the OKF `id` was recomputed for the new repository path. Status unchanged (draft / Proposed pending human acceptance).

## Context

nix and mise are the source of truth for toolchains and project versions, but all 40 modules under `zsh/modules/` are glob-sourced on every shell start (`zsh/zshrc:56-66`) with no lifecycle policy. Redundant version managers and GUI integrations keep loading, and startup hooks/PATH duplicate (e.g. `mise activate zsh` ran both from `zsh/zshrc:121` and `zsh/modules/devops/internal/mise.zsh`). The PE-699 requirements demand a decision matrix driven by "C1–C6 criteria" but reference those criteria without defining them anywhere in the repository; for this proposal the six criteria were authored (with explicit authorization) and are AUTHORITATIVE for this change.

## Decision

Classify every directory under `zsh/modules/` as ARCHIVE, DISABLE, or KEEP by applying criteria C1–C6 under the precedence rules below, record the classification here, and realize non-KEEP decisions only through the existing `ZSH_DISABLED_MODULES` / `ZSH_<MODULE>_ENABLED` mechanisms — no new exclusion branch or central blacklist in `zsh/zshrc`.

### Criteria C1–C6

> The source requirements (PE-699) referenced criteria C1–C6 but did not define them; the definitions below were authored for this proposal and are authoritative for this decision.

- **C1 — Nix/mise redundancy:** does nix or mise already own this tool's installation/version pinning?
- **C2 — Duplicate shell integration:** does the module initialize a version manager / hook that duplicates an existing startup integration (e.g. `mise activate zsh`, fnm PATH setup)?
- **C3 — Cross-boundary shared helper:** is any of the module's functions referenced from another `zsh/modules/<other>` directory or from `zsh/system/`? (Blocks ARCHIVE unless migrated.)
- **C4 — Platform scope:** is the module relevant on only one platform (osx/linux)? Disables belong in that platform's config file with a `:-true` base default, not globally.
- **C5 — Interactive/user-facing value:** does it provide user-facing commands/aliases with no automated redundancy?
- **C6 — Startup cost & reversibility:** does sourcing it add measurable startup work or make reversal hard? (Must remain reversible via existing mechanisms.)

### Criterion precedence

- C3 is a hard gate — any external reference blocks ARCHIVE and pins KEEP until migrated.
- A demonstrated C1/C2 redundancy outranks C5 when nix/mise subsumes the module's interactive value (otherwise C5 would veto every disable and the policy would be vacuous).
- C4 decides *where* a disable lives, not *whether*.
- C6 plus reversibility through existing mechanisms is a prerequisite for any non-KEEP decision.
- A constraint from an in-flight change (`make-fnm-yield-to-mise` defers fnm removal) pins KEEP temporarily.

### Decision matrix — all 40 modules

| # | Module | Decision | One-line rationale (C1–C6) |
|---|--------|----------|-----------------------------|
| 1 | ai | KEEP | C5 user-facing AI helpers; no C1/C2 redundancy, cost is file sourcing only (C6). |
| 2 | alacritty | KEEP | C4 already handled — disabled on macOS in `config/osx.zsh` over `:-true` base; config-only cost (C6). |
| 3 | aliases | KEEP | C5 core interactive UX; aliases wrap nix-owned binaries without duplicating them (C1/C2 no). |
| 4 | apps | KEEP | C5 app/webapp helpers; only cross-boundary trace is a comment in `osx/pkg/base.zsh:242` (C3 clear). |
| 5 | bitwarden | KEEP | C5 `bw` CLI helpers; no C1/C2 overlap with nix/mise. |
| 6 | clean | KEEP | C5 cleanup helpers; no C1/C2 overlap (note `clean::` grep false positive → strict prefix, C3 clear). |
| 7 | devbox | **DISABLE** | C1 devbox is a nix front-end — nix owns installs/project envs; C6 startup nix check + install-on-failure; C3 zero refs; reversible via `ZSH_DEVBOX_ENABLED=true`. |
| 8 | devops | KEEP | C3 `zsh/system/nix/pkg/direnv.zsh:7-8` calls `devops::direnv::install`; C5 central tooling; C2 duplicates fixed here (mise + atuin). |
| 9 | docker | KEEP | C5 docker workflow helpers; daemon/CLI is not version-manager territory (C1/C2 no). |
| 10 | ghostty | KEEP | C5 terminal config; cross-platform and cheap — C4/C6 raise no disable. |
| 11 | ghq | KEEP | C5 repo-management helpers; nix owning the binary is not duplication (C1 distinguishes install ownership from helper value). |
| 12 | github | KEEP | C5 `gh` aliases/workflows; no redundancy (C1/C2 no). |
| 13 | git | KEEP | C3 `zsh/system/core/internal/backup.zsh:35` calls `git::internal::get_module_path`; C5 aliases. |
| 14 | goenv | KEEP | C1/C2 point to ARCHIVE (mise owns Go; gobrew load/install at startup) but C3 — devops callers — blocks it; smoke test also pins it enabled; reclassify after migrating devops refs (follow-up). |
| 15 | hammerspoon | KEEP | C4 already handled — disabled on Linux in `config/linux.zsh`; C5 macOS automation. |
| 16 | helix | KEEP | C5 editor config; no C1/C2 overlap. |
| 17 | herdr | KEEP | C5 active workspace tooling; hosts `hrd::internal::osx::ensure_clipboard` used by the shared-helper smoke test. |
| 18 | hyprland | KEEP | C4 already handled — disabled on macOS in `config/osx.zsh`; C5 Linux WM config. |
| 19 | issues | KEEP | C5 user-facing issue lookup hook; C6 chpwd registration is the feature, not redundancy. |
| 20 | keybase | KEEP | C5 CLI helpers; C1 nix does not own keybase in this repo, C2 none — C6 install-on-failure recorded as hardening observation only. |
| 21 | mobile | KEEP | C5 mobile-dev helpers; C1/C2 no nix/mise overlap; C6 startup flutter/adb checks noted as observation. |
| 22 | mpd | KEEP | C4 already handled — disabled on macOS in `config/osx.zsh`; C5 music client helpers. |
| 23 | nodejs | KEEP | C2/C6 red (fnm eval + auto-installs) but in-flight `make-fnm-yield-to-mise` defers fnm removal and its yield logic already restores mise precedence — revisit after that change archives. |
| 24 | notify | KEEP | C5 notification helpers with tests; preexec/precmd hooks are the user-facing feature (C6 accepted). |
| 25 | nvim | KEEP | C5 editor config; no C1/C2 overlap. |
| 26 | osx | KEEP | C4 already handled — disabled on Linux in `config/linux.zsh`; C5 macOS system helpers. |
| 27 | pazi | KEEP | C5 smart-cd; `pazi init` is guarded and unique (C2 no duplicate jump-tool init). |
| 28 | python | KEEP | C5 uv/python helpers; uv does not prepend PATH shims (C2 no) — verified by acceptance test 6; install-on-failure noted (C6 observation). |
| 29 | resources | KEEP | C5 resource/package helpers; no external callers and no C1/C2 overlap. |
| 30 | rvm | **ARCHIVE** | C1 mise owns Ruby versions, C2 rvm registers chpwd/shell hooks, C3 zero external refs, C6 startup auto-install — fully superseded; remove in dedicated follow-up change. |
| 31 | rust | KEEP | C5 cargo/rustup workflow helpers; misplaced `zoxide init` in `internal/packages.zsh` is a non-lifecycle cleanup observation, not duplication (single init). |
| 32 | smolvm | KEEP | C5 integrated with herdr smolbox (active feature); `smolvm-module` spec mandates `:-true` default; cross-platform files exist (C4 n/a). |
| 33 | ssh | KEEP | C5 ssh config helpers; no C1/C2 overlap. |
| 34 | starship | KEEP | C5 prompt; single guarded `starship init` (C2 no duplicate). |
| 35 | templates | KEEP | C5 project scaffolding; no redundancy. |
| 36 | tmux | KEEP | Default already `false` (`config/base.zsh`) — C6 satisfied pre-existing; no change (note: `zsh/system/core/pkg/helper/tmux.zsh` reads `ZSH_DISABLED_MODULES` before `$CUSTOMRC`, unchanged). |
| 37 | waybar | KEEP | C4 already handled — disabled on macOS in `config/osx.zsh`; C5 Linux bar config. |
| 38 | wezterm | KEEP | C5 cross-platform terminal config; no platform asymmetry observed (C4 no). |
| 39 | yazi | KEEP | C5 file-manager config; no C1/C2 overlap. |
| 40 | zed | KEEP | C5 editor config; no C1/C2 overlap. |

Totals: ARCHIVE 1 (`rvm`), DISABLE 1 (`devbox`), KEEP 38.

## Consequences

- `devbox` becomes default-disabled (breaking on fresh shells, fully reversible per shell via `export ZSH_DEVBOX_ENABLED=true` or `ZSH_DISABLED_MODULES=""` in `$CUSTOMRC`).
- ARCHIVE removals (`rvm`) are excluded from the policy change and delivered by a dedicated follow-up change `archive-redundant-zsh-modules` referencing git history; no automatic push.
- Redundancy is concentrated in version-manager modules; C3 (goenv, git, devops, herdr) and the in-flight fnm deferral (nodejs) pin the rest.
- Six platform-scoped disables already exist; C4 mostly confirms prior work rather than demanding new changes.
- Reference searches must use strict namespace-prefix form (`(^|[^a-zA-Z0-9_])<module>::`) to avoid substring false positives (`clean::` vs `docker::internal::clean::*`, `osx::` vs `cleanup::osx::*`, `python::` vs `cleanup::python::*`).

## Alternatives Considered

- **Central blacklist / new exclusion branch in `zsh/zshrc`:** rejected — the proposal constrains delivery to the existing `ZSH_DISABLED_MODULES` / `ZSH_<MODULE>_ENABLED` mechanisms; loader changes are a non-goal.
- **Disable `nodejs`, `devops`, or `goenv` now:** rejected — pinned by the in-flight `make-fnm-yield-to-mise` change (nodejs), the C3 hard gate (goenv, devops), and the shared-helper smoke test.
- **Archiving `rvm` and `devbox` in the same change:** rejected — ARCHIVE file removals go to the dedicated follow-up change so the policy delivery stays reviewable and revertible.
- **Keep the duplicate `mise activate` in `zsh/zshrc` and guard the module instead:** rejected — `zsh/zshrc` activates first and would ignore `DEVOPS_MISE_INIT_FLAGS`, breaking the `devops-mise` spec scenarios; the module owns activation.
