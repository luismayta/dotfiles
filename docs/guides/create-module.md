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
- [Section 7: Naming Conventions](#section-7-naming-conventions)
- [Section 8: Testing](#section-8-testing)
- [Section 9: Commit](#section-9-commit)
- [Section 10: Checklist](#section-10-checklist)

---

## Three-Layer Architecture

Every module follows a strict chain:

```
plugin.zsh
  └─ config/   → environment variables and user-facing settings
  └─ internal/ → private implementation (install, sync, helpers)
  └─ pkg/      → public API functions (install, sync, setup, aliases)
```

**Layer rules:**

| Layer | Contains | Who calls it |
|-------|----------|-------------|
| `config/` | `export` env vars with defaults | Shell config, user overrides |
| `internal/` | Functions prefixed `<name>::internal::` | Only `pkg/` functions |
| `pkg/` | Functions prefixed `<name>::` | End user |

- Each layer has a `main.zsh` that sources its files.
- One layer never calls into another's `internal/` across module boundaries.
- The `pkg/` layer calls `internal/` within the same module.

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
source "${ZSH_<NAME>_PATH}/internal/main.zsh"
source "${ZSH_<NAME>_PATH}/pkg/main.zsh"
```

**Reference — [`zsh/modules/zed/plugin.zsh`](/zsh/modules/zed/plugin.zsh):**

```zsh
[[ -n "${__ZSH_ZED_LOADED:-}" ]] && return
__ZSH_ZED_LOADED=1

ZSH_ZED_PATH="${0:A:h}"

source "${ZSH_ZED_PATH}/config/main.zsh"
source "${ZSH_ZED_PATH}/internal/main.zsh"
source "${ZSH_ZED_PATH}/pkg/main.zsh"
```

**Key details:**
- Guard: `__ZSH_<NAME>_LOADED` prevents double-loading
- Path: `ZSH_<NAME>_PATH="${0:A:h}"` (zsh's `:A` modifier resolves symlinks; more robust than `dirname`)
- Chain order: config → internal → pkg (dependencies flow inward)

---

## Section 3: Config Layer

### `config/base.zsh`

Export all environment variables a module needs. Use the module name (uppercased) as prefix.

```zsh
# shellcheck shell=bash

export <NAME>_PACKAGE_NAME=<name>
export <NAME>_INSTALL_URL="https://example.com/install.sh"
export <NAME>_CONFIG_PATH="${HOME}/.config/<name>"
export ZSH_<NAME>_DATA_PATH="${ZSH_<NAME>_PATH}/data"
```

**Reference — [`zsh/modules/zed/config/base.zsh`](/zsh/modules/zed/config/base.zsh):**

```zsh
export ZED_PACKAGE_NAME=zed
export ZED_INSTALL_URL="https://zed.dev/install.sh"
export ZED_CONFIG_PATH="${HOME}/.config/zed"
export ZED_SETTINGS_FILE="settings.json"
export ZSH_ZED_DATA_PATH="${ZSH_ZED_PATH}/data"
```

**Naming rules:**
- Module env vars: `ZED_PACKAGE_NAME`, `ZED_INSTALL_URL`, `ZED_CONFIG_PATH`
- Internal paths (vars used only within the module): `ZSH_ZED_PATH`, `ZSH_ZED_DATA_PATH`
- All vars are `export`-ed so user overrides in `~/.customrc` work

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

This is where the actual work happens — installation, config sync, and helpers. All functions are prefixed `<name>::internal::` to keep them private.

### `internal/base.zsh`

Core implementation logic:

```zsh
# shellcheck shell=bash

<name>::internal::install() {
    message_info "Installing ${<NAME>_PACKAGE_NAME}..."
    curl -fsSL ${<NAME>_INSTALL_URL} | bash
    message_success "${<NAME>_PACKAGE_NAME} installed."
}

<name>::internal::config::sync() {
    rsync -avzh "${ZSH_<NAME>_DATA_PATH}/" "${<NAME>_CONFIG_PATH}/"
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

zed::internal::config::sync() {
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

## Section 5: Public Layer

Thin wrappers that expose module functionality as user-callable commands.

### `pkg/base.zsh`

```zsh
# shellcheck shell=bash

<name>::install() {
    <name>::internal::install
}

<name>::sync() {
    <name>::internal::config::sync
}

<name>::post_install() {
    message_info "Post Install ${<NAME>_PACKAGE_NAME}"
    <name>::sync
    message_success "Post Install ${<NAME>_PACKAGE_NAME}"
}
```

### `pkg/helper.zsh`

Orchestrators that compose multiple public functions:

```zsh
# shellcheck shell=bash

<name>::setup() {
    message_info "Setting up ${<NAME>_PACKAGE_NAME}..."

    if ! core::exists <name>; then
        <name>::install
    else
        message_info "${<NAME>_PACKAGE_NAME} is already installed."
    fi

    <name>::sync
    message_success "${<NAME>_PACKAGE_NAME} setup complete."
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

## Section 7: Naming Conventions

| What | Pattern | Example |
|------|---------|---------|
| Guard variable | `__ZSH_<NAME>_LOADED` | `__ZSH_ZED_LOADED` |
| Module path | `ZSH_<NAME>_PATH` | `ZSH_ZED_PATH` |
| Data path | `ZSH_<NAME>_DATA_PATH` | `ZSH_ZED_DATA_PATH` |
| Package name | `<NAME>_PACKAGE_NAME` | `ZED_PACKAGE_NAME` |
| Install URL | `<NAME>_INSTALL_URL` | `ZED_INSTALL_URL` |
| Config path | `<NAME>_CONFIG_PATH` | `ZED_CONFIG_PATH` |
| Public functions | `<name>::<verb>` | `zed::install`, `zed::sync` |
| Internal functions | `<name>::internal::<verb>` | `zed::internal::install` |
| Sub-functions | `<name>::internal::<area>::<verb>` | `zed::internal::config::sync` |

---

## Section 8: Testing

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

## Section 9: Commit

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

## Section 10: Checklist

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
- [ ] `data/` — directory for rsync config files

### Quality (all modules)

- [ ] All strings use `${<NAME>_PACKAGE_NAME}` interpolation (no hardcoded names)
- [ ] All output uses `message_*` functions (no `echo`, no `printf`)
- [ ] Uses `core::exists` / `core::ensure` (no `which`, no `command -v`)
- [ ] Module loads: `source zsh/core/main.zsh && source zsh/modules/<name>/plugin.zsh`
- [ ] Guard prevents double-loading
- [ ] Public API responds: `type <name>::install`, `type <name>::setup`

### Never

- [ ] No `core::install` reimplementations — `zsh/core/` handles this per-platform
- [ ] No `message_*` reimplementations — use `zsh/core/pkg/base.zsh`
- [ ] No `core::exists` wrappers — call `core::exists <name>` directly

---

**Reference implementation:** [`zsh/modules/zed/`](/zsh/modules/zed/) — complete example with install, config sync, and setup orchestration.
