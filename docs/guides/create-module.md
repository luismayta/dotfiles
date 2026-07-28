# How to Create a ZSH Module

This guide explains how to create a new ZSH module in the dotfiles repository. Modules extend the shell with environment variables, auto-install logic, and public commands — all following a consistent three-layer architecture.

## Table of Contents

- [Three-Layer Architecture](#three-layer-architecture)
- [Core Reuse (What You Get for Free)](#core-reuse-what-you-get-for-free)
- [Section 1: Create the Module](#section-1-create-the-module)
- [Section 2: Entry Point — `plugin.zsh`](#section-2-entry-point--pluginzsh)
- [Section 3: Config Layer](#section-3-config-layer)
- [Section 4: Internal Layer](#section-4-internal-layer)
- [Section 5: Public Layer](#section-5-public-layer)
- [Section 6: OS-Specific Files](#section-6-os-specific-files)
- [Section 7: Provider Adapter (Strategy) Pattern](#section-7-provider-adapter-strategy-pattern)
- [Section 8: Naming Conventions](#section-8-naming-conventions)
- [Section 9: Testing](#section-9-testing)
- [Section 10: Commit](#section-10-commit)
- [Section 11: Checklist](#section-11-checklist)

---

## Three-Layer Architecture

Every module follows a strict chain:

```
plugin.zsh
  └─ config/   → environment variables and user-facing settings
  └─ internal/ → private implementation (install, sync, render, helpers)
  └─ pkg/      → public API functions (install, sync, setup, aliases)
```

**Layer rules:**

| Layer | Contains | Who calls it |
|-------|----------|-------------|
| `config/` | `export` env vars with defaults | Shell config, user overrides |
| `internal/` | Functions prefixed `<name>::internal::` | Only `pkg/` functions |
| `pkg/` | Functions prefixed `<name>::` | End user |
| `data/` | Rsync templates and gomplate source files | `internal/` and `render` |

- Each layer has a `main.zsh` that sources its files.
- One layer never calls into another's `internal/` across module boundaries.
- The `pkg/` layer calls `internal/` within the same module.
- The `data/` directory holds rsync source files and gomplate templates used by `internal/` and `render`.

## Core Reuse (What You Get for Free)

Before writing any module code, know what `zsh/core/` already provides. **Never reimplement these.**

### Messaging — no `echo`, no `printf`

```zsh
message_info "Installing zed..."
message_success "Done."
message_error "Failed."
message_warning "Skipping."
```

Output: `[INFO]: Installing zed...` (with colors).

### Binary checks — no `which`, no `command -v`

```zsh
core::exists zed          # → true if zed is in $PATH
core::ensure curl          # → installs curl if missing
core::install ripgrep      # → force install via package manager
core::cargo::install eza   # → install via cargo
```

`core::ensure` is the idiomatic one-liner for "make sure this tool is available". It calls `core::exists` + `core::install` internally. The install mechanism is already handled per-platform by `zsh/core/internal/{linux,osx}.zsh` (uses `paru` on Arch, `brew` on macOS).

### Examples

```zsh
# ❌ Don't
command -v zed > /dev/null && echo "zed found"
echo "Installing zed..."

# ✅ Do
core::exists zed && message_info "zed found"
message_info "Installing zed..."
```

---

## Section 1: Create the Module

Create the full directory scaffold — every module follows the same structure:

```bash
cd zsh/modules
mkdir -p <name>/{config,internal,pkg,data}
```

Running example (reference module — `zed`):

```bash
mkdir -p zed/{config,internal,pkg,data}
```

---

## Section 2: Entry Point — `plugin.zsh`

Every module needs exactly one entry point. The module loader sources this file automatically.

```zsh
# shellcheck shell=bash
# <name> module

[[ -n "${__ZSH_<NAME>_LOADED:-}" ]] && return
__ZSH_<NAME>_LOADED=1

ZSH_<NAME>_PATH="${0:A:h}"

source "${ZSH_<NAME>_PATH}/config/main.zsh"
$ZSH_<NAME>_ENABLED || return
source "${ZSH_<NAME>_PATH}/internal/main.zsh"
source "${ZSH_<NAME>_PATH}/pkg/main.zsh"
```

**Reference — [`zsh/modules/zed/plugin.zsh`](/zsh/modules/zed/plugin.zsh):**

```zsh
[[ -n "${__ZSH_ZED_LOADED:-}" ]] && return
__ZSH_ZED_LOADED=1

ZSH_ZED_PATH="${0:A:h}"

source "${ZSH_ZED_PATH}/config/main.zsh"
$ZSH_ZED_ENABLED || return
source "${ZSH_ZED_PATH}/internal/main.zsh"
source "${ZSH_ZED_PATH}/pkg/main.zsh"
```

**Key details:**
- Guard: `__ZSH_<NAME>_LOADED` prevents double-loading
- Path: `ZSH_<NAME>_PATH="${0:A:h}"` (zsh's `:A` modifier resolves symlinks; more robust than `dirname`)
- Chain order: config → internal → pkg (dependencies flow inward)
- Toggle: `$ZSH_<NAME>_ENABLED || return` — if `ZSH_<NAME>_ENABLED` is `false`, the module exits before loading internal or pkg, letting users disable modules from `~/.zshrc`

---

## Section 3: Config Layer

### `config/base.zsh`

Export all environment variables a module needs. All variables use the `ZSH_<NAME>_` prefix to namespace them clearly.

```zsh
# shellcheck shell=bash

ZSH_<NAME>_ENABLED="${ZSH_<NAME>_ENABLED:-true}"

export ZSH_<NAME>_PACKAGE_NAME=<name>
export ZSH_<NAME>_INSTALL_URL="https://example.com/install.sh"
export ZSH_<NAME>_CONFIG_PATH="${HOME}/.config/<name>"
export ZSH_<NAME>_DATA_PATH="${ZSH_<NAME>_PATH}/data"
```

**Reference — [`zsh/modules/zed/config/base.zsh`](/zsh/modules/zed/config/base.zsh):

```zsh
ZSH_ZED_ENABLED="${ZSH_ZED_ENABLED:-true}"

export ZED_PACKAGE_NAME=zed
export ZED_INSTALL_URL="https://zed.dev/install.sh"
export ZED_CONFIG_PATH="${HOME}/.config/zed"
export ZED_SETTINGS_FILE="settings.json"
export ZSH_ZED_DATA_PATH="${ZSH_ZED_PATH}/data"
```

**Naming rules:**
- All module env vars use the `ZSH_<NAME>_` prefix: `ZSH_<NAME>_PACKAGE_NAME`, `ZSH_<NAME>_INSTALL_URL`, `ZSH_<NAME>_CONFIG_PATH`
- Internal paths (vars used only within the module): `ZSH_<NAME>_PATH`, `ZSH_<NAME>_DATA_PATH`
- All vars are `export`-ed so user overrides in `~/.customrc` work

**Backward-compatible aliases (for variable renaming):**

When renaming an existing variable, keep the old name as a backward-compatible alias to avoid breaking existing shell sessions. Define the canonical name first, then alias the old name to it:

```zsh
# Canonical name (new)
export ZSH_<NAME>_PACKAGE_NAME=<name>

# Backward-compatible alias (old — remove in next cleanup cycle)
export <NAME>_PACKAGE_NAME="${ZSH_<NAME>_PACKAGE_NAME}"
```

This pattern was used when the herdr module standardized all its variables — see [`zsh/modules/herdr/config/base.zsh`](/zsh/modules/herdr/config/base.zsh) for a complete example.

### `config/main.zsh`

Sources `base.zsh`, then dispatches to the OS-specific config. This makes the platform contract explicit — even when OS files are empty stubs today, the structure is ready when platform-specific variables are needed.

```zsh
# shellcheck shell=bash
source "${ZSH_<NAME>_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_<NAME>_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_<NAME>_PATH}/config/linux.zsh" ;;
esac
```

If your module has no OS-specific config at all (unlikely), you can omit the dispatch:

```zsh
# shellcheck shell=bash
source "${ZSH_<NAME>_PATH}/config/base.zsh"
```

---

## Section 4: Internal Layer

This is where the actual work happens — installation, sync, and helpers. All functions are prefixed `<name>::internal::` to keep them private.

### `internal/base.zsh`

Core implementation logic:

```zsh
# shellcheck shell=bash

<name>::internal::install() {
    message_info "Installing ${ZSH_<NAME>_PACKAGE_NAME}..."
    curl -fsSL ${ZSH_<NAME>_INSTALL_URL} | bash
    message_success "${ZSH_<NAME>_PACKAGE_NAME} installed."
}

<name>::internal::sync() {
    rsync -avzh "${ZSH_<NAME>_DATA_PATH}/" "${ZSH_<NAME>_CONFIG_PATH}/"
}
```

**Reference — [`zsh/modules/zed/internal/base.zsh`](/zsh/modules/zed/internal/base.zsh):**

```zsh
zed::internal::install() {
    if core::exists zed; then
        return 0
    fi
    message_info "Installing ${ZED_PACKAGE_NAME}..."
    if curl -fsSL "${ZED_INSTALL_URL}" | bash; then
        message_success "${ZED_PACKAGE_NAME} installed successfully."
    else
        message_error "Failed to install ${ZED_PACKAGE_NAME}."
        return 1
    fi
}

zed::internal::sync() {
    rsync -avzh "${ZSH_ZED_DATA_PATH}/" "${ZED_CONFIG_PATH}/"
}
```

### `internal/main.zsh`

Sources the layer, dispatches OS-specific internals, ensures dependencies, and auto-installs if missing:

```zsh
source "${ZSH_<NAME>_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_<NAME>_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_<NAME>_PATH}/internal/linux.zsh" ;;
esac

core::ensure curl

if ! core::exists <name>; then
    <name>::internal::install
fi
```

If your module has no OS-specific internal logic, you can omit the dispatch:

```zsh
source "${ZSH_<NAME>_PATH}/internal/base.zsh"

core::ensure curl

if ! core::exists <name>; then
    <name>::internal::install
fi
```

**Reference — [`zsh/modules/zed/internal/main.zsh`](/zsh/modules/zed/internal/main.zsh):**

```zsh
source "${ZSH_ZED_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_ZED_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_ZED_PATH}/internal/linux.zsh" ;;
esac

core::ensure curl

if ! core::exists zed; then
    zed::internal::install
fi
```

---

### Config Generation with Gomplate

For config files containing sensitive values (tokens, API keys), use **gomplate** templates instead of shell heredoc:

```bash
# Template at data/<name>/<name>.yaml.tpl (versioned in git)
# Uses {{ getenv "VAR_NAME" }} syntax — no shell interpolation

# Render at load time:
gomplate -f "${ZSH_<NAME>_DATA_PATH}/<name>.yaml.tpl" -o "${ZSH_<NAME>_CONFIG_PATH}/config.yaml"
```

The template is stored in `data/` and rendered by `<name>::internal::render`. This keeps secrets out of shell history and avoids escaping issues.

---

## Section 5: Public Layer

Thin wrappers that expose module functionality as user-callable commands.

### `pkg/base.zsh`

```zsh
# shellcheck shell=bash

<name>::install() {
    <name>::internal::install
}

<name>::sync() {
    <name>::internal::sync
}

<name>::post_install() {
    message_info "Post Install ${ZSH_<NAME>_PACKAGE_NAME}"
    <name>::sync
    message_success "Post Install ${ZSH_<NAME>_PACKAGE_NAME}"
}
```

### `pkg/helper.zsh`

Orchestrators that compose multiple public functions:

```zsh
# shellcheck shell=bash

<name>::setup() {
    message_info "Setting up ${ZSH_<NAME>_PACKAGE_NAME}..."

    if ! core::exists <name>; then
        <name>::install
    else
        message_info "${ZSH_<NAME>_PACKAGE_NAME} is already installed."
    fi

    <name>::sync
    message_success "${ZSH_<NAME>_PACKAGE_NAME} setup complete."
}
```

**Reference — [`zsh/modules/zed/pkg/helper.zsh`](/zsh/modules/zed/pkg/helper.zsh):**

```zsh
zed::setup() {
    message_info "Setting up ${ZED_PACKAGE_NAME}..."
    if ! core::exists zed; then
        zed::install
    else
        message_info "${ZED_PACKAGE_NAME} is already installed."
    fi
    zed::sync
    message_success "${ZED_PACKAGE_NAME} setup complete."
}
```

### `pkg/alias.zsh`

User-facing aliases (optional — create only if you have aliases):

```zsh
# shellcheck shell=bash
alias <name>=<name>::setup
```

### `pkg/alias.zsh`

Always exists, even if empty — guarantees `pkg/main.zsh` can source it unconditionally:

```zsh
# shellcheck shell=bash
alias <name>=<name>::setup
```

### `pkg/main.zsh`

```zsh
source "${ZSH_<NAME>_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_<NAME>_PATH}/pkg/osx.zsh" ;;
linux*)
  source "${ZSH_<NAME>_PATH}/pkg/linux.zsh" ;;
esac

source "${ZSH_<NAME>_PATH}/pkg/helper.zsh"
source "${ZSH_<NAME>_PATH}/pkg/alias.zsh"
```

### `pkg/osx.zsh` and `pkg/linux.zsh`

```zsh
# shellcheck shell=bash
# macOS-specific <name> public functions (currently unused)
```

```zsh
# shellcheck shell=bash
# Linux-specific <name> public functions (currently unused)
```

---

## Section 6: OS-Specific Files

OS-specific files (`osx.zsh` / `linux.zsh`) exist in the `config/`, `internal/`, and `pkg/` layers. The scaffold creates them from the start as placeholders — they make the platform contract explicit.

### Do create empty placeholders

Even when empty, OS files serve a purpose: they document that the module supports both platforms and future developers know where to add platform-specific code. The dispatch in `main.zsh` is already wired up, so adding an `osx.zsh` or `linux.zsh` implementation later is a single-file change — no structural refactor needed.

### When they become non-empty

Most modules start with empty stubs. They gain real content when you need platform-specific:

| Need | macOS (`osx.zsh`) | Linux (`linux.zsh`) |
|------|-------------------|---------------------|
| Config paths | `~/Library/Application Support/` | `~/.config/` |
| Install commands | `brew install` | `paru -S` |
| Clipboard | `pbcopy` / `pbpaste` (built-in) | `wl-copy` / `xclip` |

Start with placeholders, fill them in as the module grows.

---

## Section 7: Provider Adapter (Strategy) Pattern

For modules that support multiple interchangeable backends — such as the Docker module with 5+ container runtimes — the OS dispatch pattern extends naturally into a two-layer dispatch: OS first, then provider/adapter.

This pattern is inspired by the Docker module (see [reference](/zsh/modules/docker/)).

### When to use

Use the `adapter/` subdirectory when:

- Your module supports **3+ interchangeable implementations** of the same abstraction
- Implementations vary **significantly** in logic (not just configuration)
- Providers are expected to be **added or removed over time**

Modules with 1–2 providers and simple logic should stay flat. The overhead of `adapter/` is only justified by complexity and provider count.

### Structure

The `adapter/` subdirectory exists in `config/` and `internal/` only — not in `pkg/`, since the public API should be provider-agnostic.

```
<module>/
├── config/
│   ├── adapter/                  ← Provider-specific env vars
│   │   ├── provider-a.zsh
│   │   ├── provider-b.zsh
│   │   └── provider-c.zsh
│   ├── base.zsh                  ← Platform-agnostic defaults
│   ├── main.zsh                  ← OS dispatch → adapter dispatch
│   ├── osx.zsh                   ← Platform config
│   └── linux.zsh                 ← Platform config
├── internal/
│   ├── adapter/                  ← Provider-specific implementation
│   │   ├── provider-a.zsh
│   │   ├── provider-b.zsh
│   │   └── provider-c.zsh
│   ├── base.zsh                  ← Shared logic
│   └── main.zsh                  ← OS dispatch → adapter dispatch
└── pkg/                          ← Provider-agnostic public API
```

### Dispatch mechanics

Each layer's `main.zsh` dispatches in two stages — OS first, then provider:

```zsh
# shellcheck shell=bash
source "${ZSH_<NAME>_PATH}/config/base.zsh"

# Stage 1: OS dispatch (same as standard modules)
case "${OSTYPE}" in
  darwin*)
    source "${ZSH_<NAME>_PATH}/config/osx.zsh" ;;
  linux*)
    source "${ZSH_<NAME>_PATH}/config/linux.zsh" ;;
esac

# Stage 2: Provider dispatch — selects the active adapter
case "${<NAME>_PROVIDER}" in
  provider-a*)
    source "${ZSH_<NAME>_PATH}/config/adapter/provider-a.zsh" ;;
  provider-b*)
    source "${ZSH_<NAME>_PATH}/config/adapter/provider-b.zsh" ;;
esac
```

### Strategy hook (dynamic dispatch)

For shared logic that varies per provider, use zsh's `${+functions[name]}` to dispatch polymorphically without a hardcoded `case`. The shared `base.zsh` calls an adapter-provided hook function if it exists:

```zsh
<name>::internal::resolve::something() {
    # Respect user overrides
    if [[ -n "${<NAME>_OVERRIDE:-}" ]]; then
        return 0
    fi

    # Dynamic dispatch to adapter-level strategy hook.
    # Each config/adapter/*.zsh defines <name>::adapter::resolve::something
    # with provider-specific logic.
    if (( ${+functions[<name>::adapter::resolve::something]} )); then
        <name>::adapter::resolve::something
    fi

    # Fallback
    if [[ -z "${RESULT:-}" && -n "${FALLBACK_PATH:-}" ]]; then
        export RESULT="${FALLBACK_PATH}"
    fi
}
```

Each adapter file defines its own hook:

```zsh
# config/adapter/provider-a.zsh
<name>::adapter::resolve::something() {
    if [[ -S "/run/provider-a.sock" ]]; then
        export RESULT="unix:///run/provider-a.sock"
    fi
}
```

This keeps `base.zsh` provider-agnostic — adding a new provider means creating adapter files, not modifying shared logic.

### Adapter contract

Every adapter should document its contract in a header comment:

```zsh
#
# Provider A adapter for <name> module
#
# Contract:
#   install — ensure Provider A is installed
#   load    — ensure Provider A daemon is running and ready
#
```

Required functions per adapter:

| Function | Responsibility |
|----------|---------------|
| `<name>::adapter::resolve::something` | Resolve provider-specific runtime state |
| `<name>::internal::install` | Ensure the provider binary is available |
| `<name>::internal::load` | Ensure the provider daemon is running |

### Adding a new provider

A new provider requires changes to **5 files**:

1. Create `config/adapter/<provider>.zsh` — provider-specific env vars + strategy hooks
2. Create `internal/adapter/<provider>.zsh` — provider-specific install/load logic
3. Edit `config/main.zsh` — add case for the new provider
4. Edit `internal/main.zsh` — add case for the new provider
5. Edit `config/osx.zsh` and/or `config/linux.zsh` — add provider to auto-detection if needed

### Reference implementation

See the **[Docker module](/zsh/modules/docker/)** for a complete production example:
- 5 providers: `colima`, `lima`, `orbstack`, `podman`, `docker` (CE)
- Strategy hook: `docker::adapter::resolve::socket` dispatched from `internal/base.zsh`
- Each adapter has a documented contract header

---

## Section 8: Naming Conventions

| What | Pattern | Example |
|------|---------|---------|
| Guard variable | `__ZSH_<NAME>_LOADED` | `__ZSH_ZED_LOADED` |
| Module path | `ZSH_<NAME>_PATH` | `ZSH_ZED_PATH` |
| Data path | `ZSH_<NAME>_DATA_PATH` | `ZSH_ZED_DATA_PATH` |
| Package name | `ZSH_<NAME>_PACKAGE_NAME` | `ZSH_HERDR_PACKAGE_NAME` |
| Install URL | `ZSH_<NAME>_INSTALL_URL` | `ZSH_HERDR_INSTALL_URL` |
| Config path | `ZSH_<NAME>_CONFIG_PATH` | `ZSH_HERDR_CONFIG_DIR` |
| Backward-compat alias | `<NAME>_PACKAGE_NAME="${ZSH_<NAME>_PACKAGE_NAME}"` | `HERDR_PACKAGE_NAME="${ZSH_HERDR_PACKAGE_NAME}"` |
| Clipboard copy | `ZSH_<NAME>_CLIPBOARD_COPY_CMD` | `ZSH_HERDR_CLIPBOARD_COPY_CMD` |
| Clipboard paste | `ZSH_<NAME>_CLIPBOARD_PASTE_CMD` | `ZSH_HERDR_CLIPBOARD_PASTE_CMD` |
| Public functions | `<name>::<verb>` | `zed::install`, `zed::sync` |
| Internal functions | `<name>::internal::<verb>` | `zed::internal::install` |
| Sub-functions | `<name>::internal::<area>::<verb>` | `zed::internal::sync` |
| Render function | `<name>::internal::render` | Generates config from gomplate template |

**Why `ZSH_<NAME>_` prefix for all env vars:** The `ZSH_` prefix namespaces variables to the module system, preventing collisions with external tools or user scripts. The herdr module was standardized to this convention — see [`zsh/modules/herdr/config/base.zsh`](/zsh/modules/herdr/config/base.zsh).

**Backward-compatible aliases:** When renaming variables, keep the old name as a `export OLD_NAME="${NEW_NAME}"` alias. This prevents breaking existing shell sessions that already have the old name expanded in loaded functions. Aliases are temporary and can be removed in the next cleanup cycle. See the [herdr module](#backward-compatible-aliases-for-variable-renaming) for a complete example.

---

## Section 9: Testing

### Load the module

```zsh
source zsh/core/main.zsh && source zsh/modules/<name>/plugin.zsh
```

Expected: `[INFO]: Loading module: <name>` (once).

### Verify the guard

```zsh
source zsh/core/main.zsh && source zsh/modules/<name>/plugin.zsh && source zsh/modules/<name>/plugin.zsh
```

The loading message appears only once — the second `source` is a no-op.

### Verify public functions

```zsh
source zsh/core/main.zsh && source zsh/modules/<name>/plugin.zsh
type <name>::install    # → "function"
type <name>::setup      # → "function"
```

### Verify auto-install

If the tool is not on the system, running `source zsh/modules/<name>/plugin.zsh` should trigger installation.

---

## Section 10: Commit

This project uses conventional commits with the Goji workflow.

```bash
git add zsh/modules/<name>/
# Run goji-commit-smart — detects type (feat), scope (zsh), and issue from branch
goji-commit-smart
```

Result:

```
feat ✨ (zsh): HAD-61 add zed module with install config sync and setup
```

---

## Section 11: Checklist

### Scaffold (all files exist)

- [ ] `plugin.zsh` — idempotent guard, dynamic path, 3-layer chain
- [ ] `config/base.zsh` — env vars exported with defaults
- [ ] `config/main.zsh` — sources `base.zsh` + OS dispatch
- [ ] `config/osx.zsh` — OS-specific config (optional, only if needed)
- [ ] `config/linux.zsh` — OS-specific config (optional, only if needed)
- [ ] `internal/base.zsh` — install + sync logic
- [ ] `internal/main.zsh` — sources layer + OS dispatch, `core::ensure`, auto-install
- [ ] `internal/osx.zsh` — OS-specific internals (optional, only if needed)
- [ ] `internal/linux.zsh` — OS-specific internals (optional, only if needed)
- [ ] `pkg/base.zsh` — public wrappers (`install`, `sync`, `post_install`)
- [ ] `pkg/main.zsh` — sources layer + OS dispatch + helper + alias
- [ ] `pkg/osx.zsh` — OS-specific public functions (optional, only if needed)
- [ ] `pkg/linux.zsh` — OS-specific public functions (optional, only if needed)
- [ ] `pkg/helper.zsh` — `setup` orchestrator
- [ ] `pkg/alias.zsh` — user aliases (empty placeholder allowed)
- [ ] `data/` — directory for rsync config files and gomplate templates

### Quality (all modules)

- [ ] All strings use `${ZSH_<NAME>_PACKAGE_NAME}` interpolation (no hardcoded names)
- [ ] All output uses `message_*` functions (no `echo`, no `printf`)
- [ ] Uses `core::exists` / `core::ensure` (no `which`, no `command -v`)
- [ ] Module loads: `source zsh/core/main.zsh && source zsh/modules/<name>/plugin.zsh`
- [ ] Guard prevents double-loading
- [ ] Public API responds: `type <name>::install`, `type <name>::setup`
- [ ] `render` function for gomplate-based config generation (if config has secrets)

### Never

- [ ] No `core::install` reimplementations — `zsh/core/` handles this per-platform
- [ ] No `message_*` reimplementations — use `zsh/core/pkg/base.zsh`
- [ ] No `core::exists` wrappers — call `core::exists <name>` directly

---

**Reference implementation:** [`zsh/modules/zed/`](/zsh/modules/zed/) — complete example with install, config sync, and setup orchestration.
**AI module pattern:** [`zsh/modules/ai/`](/zsh/modules/ai/) — aggregate sync via `ai::sync`
**noti integration:** [`zsh/modules/notify/internal/adapter/noti.zsh`](/zsh/modules/notify/internal/adapter/noti.zsh) — gomplate render + sync patterns
