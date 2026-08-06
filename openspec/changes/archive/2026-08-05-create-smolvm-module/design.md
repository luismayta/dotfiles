---
## Context

See proposal.md — Why. The repository's module guide (`docs/guides/create-module.md`) mandates a three-layer architecture (`config/` → `internal/` → `pkg/` plus `data/`) with `plugin.zsh` as the single entry point. The herdr module (`zsh/modules/herdr/`) is the closest reference: same load chain, idempotency guard `__ZSH_<NAME>_LOADED`, toggle `ZSH_<NAME>_ENABLED`, `core::path::prepend` for `bin/`, and auto-install after `pkg/`. smolvm is a standalone binary distributed via GitHub releases (no package-manager package is pinned or validated by the consuming herdr smolbox plugin); the adoption decision places the binary in `~/.local/bin` and host KVM support is already verified.

## Goals / Non-Goals

**Goals:**
- Module that follows repo conventions exactly (guide checklist + herdr reference pattern)
- Deterministic install: exact version pin plus SHA256 verification before any binary touches disk
- Idempotent loading and install (no re-install on every shell start)

**Non-Goals:**
- Managing the herdr smolbox plugin or its configuration
- VM lifecycle orchestration (wrappers around `smolvm machine ...`)
- Config syncing from `data/` (smolvm needs no managed config files; `data/` exists to satisfy the scaffold contract)
- Enforcing or probing KVM support (verified once at adoption; out of scope for a shell module)

## Decisions

1. **Exact version + SHA256 constants in `config/base.zsh`** — `ZSH_SMOLVM_VERSION=1.3.2` and `ZSH_SMOLVM_SHA256=<fetched at implementation>` exported. Rationale: reproducible installs and supply-chain safety. Alternative considered: `latest` or the upstream install script — rejected: non-reproducible and no checksum verification. The SHA256 value MUST be read from the official v1.3.2 release checksums during implementation, never invented.

2. **Install to `~/.local/bin` via curl + checksum + full tarball extraction** — download the release asset to a temp file, verify the checksum, then extract the entire tarball into `~/.local/bin` with `tar --strip-components=1` (wrapper `smolvm` + `smolvm-bin` + `lib/` + `agent-rootfs/` + ext4 templates), instead of a single `install -m 0755` binary. The release is a directory distribution: the wrapper resolves its dependencies relative to itself, so everything must land together. Rationale: no sudo required, matches the adoption decision. Alternatives: brew/AUR (`paru`) — rejected: no validated package for smolvm 1.3.2.

3. **Load chain mirrors herdr exactly** — `plugin.zsh` with guard `__ZSH_SMOLVM_LOADED`, path `ZSH_SMOLVM_PATH="${0:A:h}"`, chain config → internal → pkg, and toggle `${ZSH_SMOLVM_ENABLED:-false} || return`. Rationale: consistency; reviewers already know the pattern. Alternative: single-file module — rejected: violates the guide checklist.

4. **Dependency and output conventions** — `core::ensure curl` (and `sha256sum` where not guaranteed) in `internal/main.zsh`; checksum dispatch by OSTYPE: `sha256sum` on Linux, `shasum -a 256` on macOS (already implemented); all output via `message_*`; existence checks via `core::exists`. Rationale: core-reuse rules in the guide (never reimplement).

5. **Auto-install on load** — `if ! core::exists smolvm; then smolvm::internal::install; fi` after `pkg/` sources, same as herdr. Rationale: zero-touch setup on new hosts.

## Risks / Trade-offs

- [Checksum mismatch or release asset URL drift] → install aborts with `message_error`; no binary is installed; constants live in one place (`config/base.zsh`)
- [Binary installed but not found on PATH] → post-install `core::exists smolvm` check with `message_warning` and non-zero return if missing (herdr pattern)
- [Upstream publishes new versions] → pin stays at 1.3.2; upgrade is a two-constant change (`ZSH_SMOLVM_VERSION` + `ZSH_SMOLVM_SHA256`), documented in `README.yaml`
- [Module disabled mid-session] → toggle returns before internal/pkg load, no side effects

## Migration Plan

New module — no migration path for existing users. Rollback: delete `zsh/modules/smolvm/` and the `module-smolvm` entry in the root `Taskfile.yml`; unset `ZSH_SMOLVM_ENABLED`.

## Open Questions

None — the SHA256 value is a data constant fetched at implementation time, not a design unknown.
