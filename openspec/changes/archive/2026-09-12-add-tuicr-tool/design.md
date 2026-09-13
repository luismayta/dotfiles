## Context

See proposal.md — Why. The `ai` module manages tools with a three-layer architecture (config/internal/pkg) plus a data layer for config templates. tuicr is a standalone Rust CLI (code review TUI) with no shell hooks, so it follows the PATH-only integration pattern from `docs/guides/implement-tool-in-module.md`, mirroring the existing hunk integration (`zsh/modules/ai/{config,internal,pkg}/hunk.zsh`, `data/hunk/config.toml`). Requirements are defined in `specs/tuicr-ai-tool/spec.md`.

## Goals / Non-Goals

**Goals:**
- Integrate tuicr through the standard 4-layer lifecycle: config vars → internal load/install → public API → data template.
- Register tuicr in `ZSH_AI_TOOLS` so `ai::internal::packages::install` and the module load chain pick it up automatically.
- Keep the integration consistent with hunk/jcode so future tools can copy the same shape.

**Non-Goals:**
- No shell hooks, completions, or keybindings eval (tuicr is a TUI; its vim keybindings live inside its own config, not the shell).
- No changes to `plugin.zsh` (it already chains config → internal → pkg).
- No changes to existing specs or other tools' behavior.

## Decisions

1. **PATH-only pattern (no eval).** tuicr provides no `init zsh` hook, so `ai::internal::tuicr::load` only prepends the binary dir to PATH — same as hunk/bruno. Alternative (eval pattern) rejected: nothing to eval.

2. **Install via `cargo install tuicr`.** tuicr is distributed through crates.io. Unlike hunk (npm) or jcode (curl), the installer must verify `core::exists cargo` first and fail with `message_error` if the Rust toolchain is missing. Alternative (prebuilt binary download) rejected: no official binary release channel is guaranteed; cargo is the documented install path.

3. **Install root aligned with `ZSH_AI_TUICR_BIN_PATH`.** `cargo install` defaults to `$CARGO_HOME/bin` (`~/.cargo/bin`), but the spec pins `ZSH_AI_TUICR_BIN_PATH` to `${HOME}/.local/bin`. The install function SHALL use `cargo install --root "${HOME}/.local" tuicr` so the binary lands exactly where the load function prepends. Alternative (leave default cargo home) rejected: would require prepending two dirs or a symlink, breaking the single-BIN_PATH contract.

4. **Load guard via `core::exists tuicr`.** Per RD-179, `ai::internal::tuicr::load` checks `core::exists tuicr` (command availability) rather than hunk's `[ -e ... ]` file check. This is more robust once the binary is on PATH and matches the module's `core::exists` convention.

5. **Config sync via `cp` with `mkdir -p`.** `ai::tuicr::config::sync` copies `data/tuicr/config.toml` to `~/.config/tuicr/config.toml`, creating the target dir first and warning if the template is missing — identical to hunk's `config::sync`.

6. **Data template: catppuccin-mocha + vim keybindings.** Per RD-179, `data/tuicr/config.toml` sets `theme = "catppuccin-mocha"` and vim-style keybindings (j/k navigation, q quit, etc.), following tuicr's CONFIG.md schema.

7. **Registration in three files.** `config/base.zsh` (source + `ZSH_AI_TOOLS` entry), `internal/main.zsh` (source + `ai::internal::tuicr::load` call), `pkg/main.zsh` (source). Placement mirrors hunk's exact positions in each file.

## Risks / Trade-offs

- [Rust toolchain required at install time] → `ai::internal::tuicr::install` guards on `core::exists cargo` and returns 1 with `message_error` before attempting anything.
- [`cargo install --root` diverges from default cargo layout] → Explicit and documented; `--root "${HOME}/.local"` keeps BIN_PATH truthful. Users with a custom `CARGO_HOME` are unaffected since we pin the root.
- [Config sync overwrites a user-edited `~/.config/tuicr/config.toml`] → Sync is explicit (never automatic at load); same behavior as hunk. Users can skip sync to keep local edits.
- [cargo install compile time for a Rust TUI] → One-time cost; `message_info` feedback keeps the user informed. No mitigation needed beyond messaging.

## Migration Plan

- **Deploy**: Add the 4 new files, apply the 3 registration edits, then source the module and run `ai::tuicr::install` + `ai::tuicr::config::sync` to provision.
- **Rollback**: Delete `config/tuicr.zsh`, `internal/tuicr.zsh`, `pkg/tuicr.zsh`, `data/tuicr/` and revert the three registration edits. No other tool is affected.

## Open Questions

None — all decisions are resolved above and reflected in the spec.