## Context

`hadenlabs/zsh-goenv` is an external zsh plugin that manages Go versions via **gobrew** (not traditional goenv). It provides Go version management, PATH/GOPATH setup, and Go package tool management via `go install`. The plugin follows the same three-layer architecture (config → internal → pkg) used by the existing core module, making it a natural candidate for migration into `zsh/modules/`.

Three previous migrations (brew, rust, fnm) have established a proven pattern: multi-file module with OS dispatch at each layer, idempotency guard, module root path variable, and auto-install side-effects in the pkg layer.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/goenv/` following the canonical three-layer pattern (config/, internal/, pkg/)
- Port all 18 `goenv::*` functions preserving exact namespaces and behavior
- Add idempotency guard (`__ZSH_GOENV_LOADED`) to prevent double-sourcing
- Remove `hadenlabs/zsh-goenv` from `zsh/zsh_plugins.txt`
- Port all config variables (GOENV_*, GOBREW_*, GO111MODULES, GOENV_VERSIONS, GOENV_VERSION_GLOBAL, GOENV_INSTALL_PACKAGES)
- OS dispatch at each layer with darwin*/linux* placeholders (source has no platform-specific code)

**Non-Goals:**
- No changes to Go tooling behavior, version selection, or package lists
- No changes to PATH/GOPATH semantics
- No new functionality beyond what the external plugin provides
- No changes to `zsh/zshenv` or `mod/` directory

## Decisions

1. **Module root path variable: `GOENV_PATH` (not `ZSH_GOENV_PATH`)**
   - Source uses `ZSH_GOENV_PATH` but `GOENV_*` prefix is not used by any exported env var — the module root variable (`GOENV_PATH`) is purely internal and won't collide with user-facing vars. This follows the fnm precedent of ensuring no collision with `export`-ed config variables (`ZSH_FNM_PATH` was used because `FNM_PATH` was already exported; no such conflict exists here since goenv exports `GOENV_ROOT` not `GOENV_PATH`).

2. **Config variables remain exported** — All exported vars (`GO111MODULES`, `GOENV_ROOT`, `GOENV_ROOT_BIN`, `GOBREW_*`, `GOENV_VERSIONS`, `GOENV_VERSION_GLOBAL`, `GOENV_INSTALL_PACKAGES`, etc.) stay as `export` in `config/base.zsh` for consistency with brew and fnm patterns.

3. **Auto-install side-effects in `internal/main.zsh`** — Following the source: `goenv::internal::load` is called automatically on module load, and missing curl/gobrew triggers auto-install. This matches the source behavior and the established pattern (rust module does the same for cargo).

4. **OS-install functions defined unconditionally in `internal/base.zsh`** — Following the brew/rust/fnm pattern, platform install implementations go in `internal/base.zsh` rather than OS-specific files, since the install logic is identical across platforms.

5. **Source chain: plugin.zsh → config/main.zsh → internal/main.zsh → pkg/main.zsh** — Same order as the source plugin and identical to brew/rust/fnm modules.

6. **`pkg/main.zsh` includes `helper.zsh` and `alias.zsh`** — Following the core module pattern, with stubs sourced at the end of the pkg chain even if empty (for future extensibility).

## Risks / Trade-offs

- [Maintaining gobrew compatibility] → gobrew is a third-party tool (`kevincobain2000/gobrew`); if its install API changes, the module breaks. Mitigation: same risk as the external plugin, no change in exposure.
- [Large `GOENV_INSTALL_PACKAGES` array (34 packages)] → The array is large (~130 lines) but is purely declarative data in `config/base.zsh`. Trade-off: inline array vs external file. Decision: keep inline for consistency with source and all existing modules.
- [Auto-install gobrew on every shell start if missing] → Low risk since once installed, the auto-install guard (`if ! core::exists gobrew`) prevents re-execution. On fresh systems, this adds ~2s to first shell start.