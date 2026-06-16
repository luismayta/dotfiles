## Context

The `zsh/modules/devops/` module manages DevOps tool installations (kubectl, k9s, helm, tfenv), shell aliases, and config syncing. It follows a 3-layer architecture: `config/` (env vars), `internal/` (implementation), `pkg/` (public API). An audit revealed 10 areas of technical debt ranging from typos to architectural coupling.

## Goals / Non-Goals

**Goals:**
- Replace 3 no-op upgrade stubs with real implementations delegating to `core::upgrade`
- Fix typo "method not implement" → "method not implemented" in `base.zsh`, `k9s.zsh`, `helm.zsh`
- Add Linux k9s config path support via platform dispatch in `config/`
- Remove redundant `core::ensure helm` from kubectl factory (helm has its own)
- Replace fragile `cd && git pull && cd -` with `git -C` in tfenv upgrade
- Drop no-op `devops::helm::post_install` in favor of module-level handler

**Non-Goals:**
- No API changes — all public function signatures remain identical
- No new tools or tool integrations
- No restructuring of the 3-layer architecture
- No changes to the 35 kubectl aliases or krew plugin list

## Decisions

1. **core::upgrade delegation for stubs** — Rather than implementing tool-specific upgrade logic in the devops module, delegate to `core::upgrade` which already handles Homebrew/formulae upgrades. This avoids duplicating package-manager awareness and keeps the devops module thin.

2. **Platform dispatch in config/ (not pkg/)** — The k9s config path variable belongs in `config/` where platform dispatch (OS switch) already lives. This keeps `config/base.zsh` as the single source of truth for defaults, with `config/linux.zsh` and `config/osx.zsh` overriding as needed.

3. **Remove helm from kubectl factory** — `core::ensure helm` inside kubectl's factory creates an invisible dependency. Helm's own factory already runs on load. Removing it from kubectl makes the dependency graph explicit and follows the principle of least surprise.

4. **git -C over cd** — Using `git -C "$path" pull` instead of `cd "$path" && git pull && cd -` avoids: stdout pollution from `cd -`, word-splitting on paths with spaces, and failure if `cd -` target was deleted.

5. **Drop no-op post_install** — `devops::helm::post_install` only logs a message with no side effects. The module-level `devops::post_install` already serves as the lifecycle hook. Removing the no-op reduces surface area.

## Risks / Trade-offs

- **[Risk]** `core::upgrade` may not exist or may behave differently than expected → **Mitigation**: Verify `core::upgrade` signature and behavior before implementation; fall back to tool-native upgrade if incompatible.
- **[Risk]** Linux k9s path `~/.config/k9s` might differ on some distributions → **Mitigation**: Use the standard XDG base directory (`${XDG_CONFIG_HOME:-$HOME/.config}/k9s`), which covers all Linux distributions.
- **[Risk]** Removing helm from kubectl factory could break users who depend on helm being ensured before kubectl completion loads → **Mitigation**: Helm factory is sourced before pkg/ functions run; the ordering in `internal/main.zsh` already ensures helm's factory fires independently.
