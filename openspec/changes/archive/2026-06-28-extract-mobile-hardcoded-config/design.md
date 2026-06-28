## Context

The mobile module at `zsh/modules/mobile/` has config files (`config/*.zsh`) and implementation files (`internal/*.zsh`). The previous `sdkman-android-install` change established the pattern: hardcoded values in `internal/` get extracted as exportable environment variables in `config/` with `${VAR:-default}` fallback syntax.

Two remaining hardcoded values were identified:

1. **cmdline-tools version**: `internal/base.zsh` line 38 embeds version `11076708` directly in the download URL string
2. **SDKMAN install path**: `internal/base.zsh` line 18 uses `~/.sdkman/bin/sdkman-init.sh` directly instead of via a variable

Both are small, well-scoped extractions — each is a single-line change in `internal/base.zsh` plus a single-line addition in `config/android.zsh`.

## Goals / Non-Goals

**Goals:**
- Make `ANDROID_CMDLINE_TOOLS_VERSION` configurable via `config/android.zsh` with `11076708` as default
- Make `SDKMAN_DIR` configurable via `config/android.zsh` with `~/.sdkman` as default
- Use `$SDKMAN_DIR` in `internal/base.zsh` instead of the hardcoded path string
- Maintain exact backward compatibility — all default values match current hardcoded values

**Non-Goals:**
- Not changing iOS tool installation commands (brew/gem tool names are not config values)
- Not refactoring the architecture or moving files
- Not touching any other module

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Config file | `config/android.zsh` | Both values are Android/SDKMAN-related; this file already holds `SDKMAN_INSTALL_URL` and `SDKMAN_JAVA_VERSION` |
| Variable naming | `ANDROID_CMDLINE_TOOLS_VERSION`, `SDKMAN_DIR` | Consistent with existing `ANDROID_SDK_VERSION`, `SDKMAN_JAVA_VERSION` style (UPPER_SNAKE_CASE with ANDROID_/SDKMAN_ prefix) |
| Default pattern | `${VAR:-default}` | Same pattern used by all existing config variables; allows override via env before sourcing |
| `SDKMAN_DIR` scope | Config-level export | SDKMAN itself uses `$SDKMAN_DIR` as its install root when set; this aligns with SDKMAN's own convention |

## Risks / Trade-offs

- **Path quoting**: `SDKMAN_DIR` default `~/.sdkman` uses tilde expansion. This works in zsh and bash but requires careful quoting to avoid literal tilde. Mitigation: test sourcing from both interactive and non-interactive shells.
- **No rollback needed**: Both are additive changes with zero behavioral difference at default values. If a problem surfaces, just remove the two config lines — the hardcoded values are still in git history for comparison.
