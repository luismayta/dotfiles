## Context

See proposal.md — Why. The AI module (`zsh/modules/ai/`) follows a three-layer architecture (config/, internal/, pkg/) with conventions `ZSH_AI_<TOOL>_` variables, `ai::internal::<tool>::<action>` private functions, and `ai::<tool>::<action>` public wrappers. Tools register in the `ZSH_AI_TOOLS` array (`config/base.zsh`) and aggregate into `ai::sync` / `ai::install` (`pkg/base.zsh`, `internal/tools.zsh`). Reference implementations: `jcode-ai-tool` spec and the opencode/bruno tools.

OmniRoute is an npm-distributed AI gateway (binary `omniroute`, config in `~/.omniroute/`, no shell hooks). Requirements are defined in specs/omniroute-ai-tool/spec.md.

## Goals / Non-Goals

**Goals:**
- Integrate OmniRoute into the module lifecycle: install, upgrade, sync, PATH availability.
- Follow the existing three-layer conventions exactly (no new patterns).
- Zero-config basic usage: OmniRoute works out-of-the-box without secrets.

**Non-Goals:**
- Managing OmniRoute's internal state (SQLite, providers, API keys) — that is OmniRoute's own runtime concern.
- Templating `~/.omniroute/.env` — OmniRoute auto-generates its secrets on first boot; we do not manage secrets.
- Shell hooks / completions — OmniRoute provides none (PATH-only pattern).

## Decisions

### D1: PATH-only pattern (no shell hooks)

OmniRoute exposes a standalone CLI via npm global bin, which is already on PATH. `ai::internal::omniroute::load` is therefore a guard-only function: `core::exists omniroute || return`.

- **Alternative considered**: eval pattern (`eval "$(omniroute init zsh)"`) — rejected, OmniRoute has no shell init.

### D2: Install via bun variable, not core::install

OmniRoute is distributed via npm, but the environment uses bun as the package manager (repo convention: bruno `bun add -g`, openspec `bun add -g <pkg>@latest`). Following the bruno pattern, declare `ZSH_AI_OMNIROUTE_INSTALL_CMD="bun add -g"` and `ZSH_AI_OMNIROUTE_PACKAGE_NAME=omniroute` in config, and execute `${ZSH_AI_OMNIROUTE_INSTALL_CMD} ${ZSH_AI_OMNIROUTE_PACKAGE_NAME}` in internal, guarded by `core::exists bun`.

- **Alternative considered**: `core::install omniroute` — rejected, no native package reliably provides it.

### D3: Upgrade via bun reinstall

Upgrade follows the openspec pattern in the same module: `bun add -g omniroute@latest --force`, guarded by `core::exists bun`. If the binary is missing, upgrade falls back to install.

- **Alternative considered**: built-in updater `omniroute update --apply` — rejected, it shells out to npm internally, which conflicts with the bun-based environment.

### D4: Sync as optional data overlay

`ai::internal::omniroute::sync` rsyncs `data/omniroute/` → `~/.omniroute/` only when module data exists. OmniRoute generates its own config on first boot, so module data is an optional overlay, not a requirement.

- **Alternative considered**: gomplate render of `.env` — rejected, `.env` holds secrets and OmniRoute auto-generates them.

### D5: Registration in four locations

1. `config/base.zsh` — source `config/omniroute.zsh` + add `omniroute` to `ZSH_AI_TOOLS`
2. `internal/main.zsh` — source `internal/omniroute.zsh` + call `ai::internal::omniroute::load`
3. `pkg/main.zsh` — source `pkg/omniroute.zsh`
4. `pkg/base.zsh` — add `ai::omniroute::sync` to `ai::sync`

`plugin.zsh` needs no change (it chains the three main.zsh files).

## Risks / Trade-offs

- [Node version incompatibility] OmniRoute requires Node >=22.22.2 <23 or >=24 <27 → Mitigation: `post_install` guidance points to `omniroute doctor` for diagnostics; npm engine warnings surface at install time.
- [bun global write permission] `bun add -g` may fail without write access to the bun global bin → Mitigation: install function reports `message_error` and returns 1; user fixes bun global setup.
- [Native optional deps build failure] better-sqlite3/keytar need python3/make/g++ → Mitigation: bun resolves optional deps at install time; system deps documented in `post_install` guidance.
- [Sync overwrites user config] rsync of `data/omniroute/` could clobber local changes → Mitigation: data dir is empty by default (no files shipped), so sync is a no-op until the user adds overlay files deliberately.

## Migration Plan

Additive change — no migration of existing data:

1. Add the three new files (config/, internal/, pkg/).
2. Register in `ZSH_AI_TOOLS` + source lines + `ai::sync`.
3. Rollback: remove the three files, the registry entry, the source lines, and the `ai::sync` line. No other module state is touched.

## Open Questions

None — deferrable unknowns (e.g., whether to ship a `data/omniroute/` overlay) do not change the specs, approach, or task breakdown; the sync requirement already handles the empty-data case.