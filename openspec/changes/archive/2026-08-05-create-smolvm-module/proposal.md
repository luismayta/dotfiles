---
## Why

The dotfiles repository manages CLI tools through modular zsh modules, but no module exists for `smolvm` — the Apache-2.0 microVM engine from smol-machines that the herdr `smolbox` plugin (`carze/herdr-smolmachine`) uses to run coding agents in ephemeral microVMs. Issue RD-62 adopts smolvm pinned at **v1.3.2** (the version validated by the plugin), installed as a binary in `~/.local/bin` on a KVM-verified host (CachyOS, `/dev/kvm` 666 + vmx flag), so the tool needs a first-class module following the repository's module guide.

## What Changes

- Create `zsh/modules/smolvm/` following the three-layer architecture from `docs/guides/create-module.md` (`config/`, `internal/`, `pkg/`, plus `data/`)
- Add `plugin.zsh` as the single entry point sourced by zshrc, chaining `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh` with idempotency guard `__ZSH_SMOLVM_LOADED`
- Make the module disable-able via the `ZSH_SMOLVM_ENABLED` variable (herdr module pattern)
- Add `internal/install.zsh`: download official release v1.3.2, verify SHA256 checksum, install binary to `~/.local/bin`, `core::ensure` dependencies
- Add post-install verification: `smolvm --version` reports 1.3.2 and `smolvm machine run --help` responds
- Add `README.yaml` + `Taskfile.yml` (`readme` task using `{{.README_MODULE_TEMPLATE}}`) and register the module in the root `Taskfile.yml`
- Generate `README.md` from the shared `provision/templates/README.module.tpl.md` template

## Capabilities

### New Capabilities
- `smolvm-module`: ZSH module that installs, verifies, and manages the `smolvm` microVM engine (pinned v1.3.2) with idempotent loading and an enable/disable toggle

### Modified Capabilities

*(None — no existing specs are changing.)*

## Impact

- **Module**: `zsh/modules/smolvm/` (new) — `plugin.zsh`, `config/`, `internal/`, `pkg/`, `data/`, `README.yaml`, `Taskfile.yml`
- **Root `Taskfile.yml`**: register `module-smolvm` taskfile entry
- **No external API changes**: new functions follow the repo naming conventions (`smolvm::*` public, `smolvm::internal::*` private)
- **Dependencies**: `curl` (via `core::ensure`), `sha256sum` for checksum verification, `~/.local/bin` on PATH
- **Reference pattern**: `zsh/modules/herdr/` (same load chain, idempotency guard, and toggle semantics)
---