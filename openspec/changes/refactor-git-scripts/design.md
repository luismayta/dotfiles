## Context

The `zsh/modules/git/bin/` directory contains 25 git helper scripts curated over time from various sources. The current state has:

- Mixed shebangs (`#!/usr/bin/env bash`, `#!/bin/sh`, `#!/bin/bash`)
- One Ruby script (`git-wtf`) requiring an external runtime
- Redundant scripts (`git-root` and `git-root-directory`)
- Deprecated commands (`git filter-branch` in `git-change-author`)
- No test coverage
- No documentation

## Goals / Non-Goals

**Goals:**
- Remove Ruby dependency by replacing `git-wtf` with a bash-native equivalent
- Unify all scripts to use `#!/usr/bin/env bash` for portability
- Eliminate redundant scripts
- Add test coverage for critical scripts
- Document the toolkit for discoverability

**Non-Goals:**
- Rewrite all scripts from scratch (preserve existing logic where correct)
- Add new scripts beyond the `git-wtf` replacement
- Migrate to a different shell (zsh/fish)
- Add CI/CD pipeline (separate initiative)

## Decisions

### D1: Replace `git-wtf` with `git-status-enhanced`

**Decision**: Write a new `git-status-enhanced` script in bash that provides branch state visualization.

**Rationale**: `git-wtf` is 364 lines of Ruby with features like `.git-wtfrc` config, `--long`, `--short`, `--all`, `--relations`. The core value is showing branch state vs remote. A focused bash rewrite covers 90% of use cases without the Ruby dependency.

**Alternatives considered**:
- Alias `git wtf` to `git status` → Loses branch relationship context
- Keep Ruby script → Maintains dependency, inconsistent with rest of toolkit
- Port to Python → Introduces new dependency, same problem

### D2: Consolidate git-root scripts

**Decision**: Keep `git-root` (more feature-rich with `--relative`), remove `git-root-directory`.

**Rationale**: `git-root` is a superset of `git-root-directory`. The simpler version adds no value.

### D3: Test framework selection

**Decision**: Use `bats-core` (Bash Automated Testing System) for tests.

**Rationale**: 
- Native bash — no external runtime needed
- Simple syntax familiar to shell developers
- Active community, well-documented
- Can be installed via package manager (brew, apt)

**Alternatives considered**:
- shunit2 → Heavier, less bash-native feel
- Plain bash functions → No test discovery, reporting, or isolation
- pytest → Requires Python, overkill for shell scripts

### D4: Shebang unification

**Decision**: Standardize on `#!/usr/bin/env bash` for all scripts.

**Rationale**: Most portable across systems (works on macOS, Linux, BSD). Already used by most scripts. Allows bash-specific features while maintaining portability.

## Risks / Trade-offs

- **[Risk] `git-status-enhanced` may not cover all `git-wtf` use cases** → Mitigation: Document known limitations, users can install `git-wtf` separately if needed
- **[Risk] Renaming/removing scripts may break user aliases** → Mitigation: Check for aliases in dotfiles, provide migration notes
- **[Risk] `git-filter-repo` not installed by default** → Mitigation: Add installation check in `git-change-author`, fallback to `git filter-branch` with deprecation warning
- **[Trade-off] Tests add maintenance burden** → Accepted: Tests prevent regressions, worth the cost for critical scripts
