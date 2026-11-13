# Design

## Context

The `nix` module currently installs tools via ad-hoc inline `nix profile install/add` calls in `zsh/system/nix/internal/linux.zsh` and `osx.zsh` (direnv). The git module installs delta analogously in `zsh/modules/git/internal/delta.zsh` and nouses nix-direnv spec governs idempotent behavior from devops. The notify module has a nix-or-core fallback in `zsh/modules/notify/internal/adapter/noti.zsh`. See proposal.md - Why.

## Goals / Non-Goals

**Goals:**
- Provide a shared `core::nix::package` helper (public wrapper + cross-OS implementation) for nix package installation with binary guards.
- Migrate inline `nix profile install/add` calls in git, nix modules, notify, and devops to use the helper.
- Refactor nix command verb detection into feature probe (not OS branching).
- Separate "binary exists" from "package installed" detection.
- Support nix-darwin respect (skip user-profile install, warn).
- Document the nix pattern and guard rules in the tool-implementation guide.

**Non-Goals:**
- Migration of existing `core::install` sites (101+ remaining — opportunistic only).
- Pinning nixpkgs ref (future).
- Changing shell load order or zshrc configuration.

## Decisions

- **Namespace `core::nix::package::*`**: Public wrappers in `zsh/system/core/pkg/nix.zsh`, internal implementation in `zsh/system/core/internal/nix.zsh`. Separate from `core::install` (native pkg install) because retaining native pkg names (apt/paru/brew) prevents name translation and preserves cask support. See `zsh/system/core/pkg/nix.zsh`现有 `core::nix::install/exists/ensure`.
- **Per-tool config var `*_NIX_PACKAGE="nixpkgs#<attr>"`**: Precedent from `GIT_DELTA_NIX_PACKAGE` and `NIX_DIRENV_NIX_PACKAGE`. Preserves `*_PACKAGE_NAME` for native/message label use.
- **Feature-detect verb, not OS**: Probe `nix profile --help` once on first call; store verb in `$ZSH_NIX_PROFILE_INSTALL_VERB`. Avoids duplicate detection in linux.zsh vs osx.zsh (today duplicative). Always pass `--extra-experimental-features 'nix-command flakes'` for flake references.
- **Binary guard first, then profile detection**: `core::nix::package::install "<flake-ref>"` checks `core::exists "<attr>"` (cheap PATH check), then lists profile packages (nix-direnv spec proves binary presence is insufficient). Return early if binary found.
- **nix-darwin skip+warn**: If `ZSH_NIX_DARWIN_AVAILABLE=true`, skip user-profile install path and log warning message; still run command from nix-darwin's PATH. Matches nix-direnv spec "Plugin ya gestionado por nix-darwin" behavior.
- **Required nix, not auto-installed**: If nix is absent from all profiles after nix PATH sourcing fallback, `message_error` + return 1. No auto-install of nix (consistent with `nix::internal::nix::install` warn-only behavior in `zsh/system/nix/internal/linux.zsh`).
- **Helper owns upgrade**: `core::nix::package::upgrade "<profile>"` → `nix profile upgrade "<profile>"`. Explicit upgrade path prevents drift from call sites that call `nix profile install` later.
- **Core pkg main sourcing**: `zsh/system/core/pkg/main.zsh` already sources `pkg/nix.zsh` after `pkg/base.zsh`; internal implementation goes into `pkg/` file within internal directory (already chained by `core/main.zsh` → internal/ → pkg/ pattern). No additional wiring changes needed.

## Risks / Trade-offs

- **Verb detection needs fallback for older nix**: If probe fails (nix not responsive or Help text malformed), default to `nix profile install` (widely supported) and log info. Mitigation: set `$ZSH_NIX_PROFILE_INSTALL_VERB` on first success; subsequent calls read it.
- **Profile listing cost**: `nix profile list` per install could be slow if profile is large. Mitigation: check binary first (90%+ checks short-circuit). Consider caching list result if repeated calls happen in same shell session.
- **nix-darwin PATH shadowing**: nix-darwin root PATH may override profile PATH during install attempt. Mitigation: devops/linux.zsh already sources profile scripts before calling nix; helper does same fallback.
- **Binary mismatch (same attr, different output)**: A given nixpkgs attribute might provide multiple binaries (e.g., `ripgrep` = binary + rgrep wrapper). Mitigation: guard on `<attr>` binary; if desired variant missing, user must pin output via flake output path (out of scope).
- **Flake ref vs attr-only**: Spec allows full flake ref (e.g., `github:NixOS/nixpkgs/ref/main#...`). Mitigation: pass string directly to `nix profile install/add`; no parsing.