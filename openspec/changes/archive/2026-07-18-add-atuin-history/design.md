## Context

The devops zsh module follows a three-layer architecture (config → internal → pkg) to manage DevOps tooling lifecycle. Each tool gets config vars, internal implementation functions, and public-facing pkg functions. Atuin is a Rust-based shell history manager that provides encrypted sync, fuzzy search, and AI assistance — replacing the default ZSH history mechanism.

Current state: No Atuin integration exists. Shell history is managed by standard ZSH `HISTFILE`/`HISTSIZE` settings.

## Goals / Non-Goals

**Goals:**
- Install Atuin via the official cross-platform installer
- Initialize Atuin shell integration (`atuin init zsh`) with opt-out sync
- Follow the exact three-layer convention used by tfenv, k9s, helm, etc.
- Add Atuin to `DEVOPS_TOOLS` for lifecycle management
- Provide a clean upgrade path via `core::upgrade`

**Non-Goals:**
- Self-hosting the Atuin sync server (users handle this separately)
- Migrating existing shell history into Atuin (user runs `atuin import` manually)
- Modifying existing ZSH history settings (Atuin replaces them at runtime)
- Adding Atuin AI features (separate concern, can be added later)

## Decisions

### 1. Install method: Official curl installer

**Decision**: Use `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh` for installation.

**Rationale**: This is Atuin's official install method. It handles platform detection, binary placement, and version management. Alternative considered: Homebrew (`brew install atuin`) — rejected because not all machines have Homebrew, and the official installer is the canonical path.

### 2. Shell integration: `atuin init zsh` with explicit config

**Decision**: Call `atuin init zsh` in the internal factory, with `DEVOPS_ATUIN_INIT_FLAGS` for customization.

**Rationale**: `atuin init zsh` sets up the history hook, keybindings (Ctrl-R search), and prompt integration. Using a configurable flags array lets users opt into sync (`--disable-up-arrow`) or other features without modifying the module.

### 3. Config namespace: `DEVOPS_ATUIN_*`

**Decision**: All Atuin config vars use `DEVOPS_ATUIN_` prefix.

**Rationale**: Consistent with `DEVOPS_K9S_*`, `DEVOPS_TFENV_*`, `DEVOPS_KUBECTL_*` patterns. Key vars:
- `DEVOPS_ATUIN_PACKAGE_NAME` — display name
- `DEVOPS_ATUIN_CONFIG_DIR` — Atuin config directory (`~/.config/atuin`)
- `DEVOPS_ATUIN_INIT_FLAGS` — extra flags for `atuin init zsh`

### 4. No data/ directory needed

**Decision**: Skip `data/atuin/` — Atuin manages its own config via `atuin init` and `~/.config/atuin/`.

**Rationale**: Unlike k9s (which has static YAML configs), Atuin's config is generated dynamically by its own CLI. No static files to sync.

## Risks / Trade-offs

- **[Risk] Network dependency for install** → Mitigated by `core::ensure` pattern — only installs if binary not found. Offline machines can pre-install manually.
- **[Risk] History migration** → Not handled automatically. Users must run `atuin import bash`/`atuin import zsh` manually. Documented in post_install message.
- **[Risk] Keybinding conflicts** → Atuin binds Ctrl-R by default. Users with existing Ctrl-R bindings may need to adjust. Mitigated by making init flags configurable.
- **[Trade-off] No AI features in initial scope** → Atuin AI is free during testing but may change. Keeping it out of initial integration avoids scope creep. Can be added as a follow-up capability.
