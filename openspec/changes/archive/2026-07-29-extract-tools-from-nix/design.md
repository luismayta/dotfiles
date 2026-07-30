## Context

The nix module currently bundles two unrelated responsibilities: Nix package management and direnv/nix-direnv tooling. The core module also has a direnv shell hook, creating a cross-module dependency where no single module owns the full direnv lifecycle.

The tool implementation guide (`docs/guides/implement-tool-in-module.md`) defines a three-layer pattern (config/internal/pkg) that tools like atuin and bruno already follow under the devops module. Extracting direnv into the devops module aligns it with this established pattern.

## Goals / Non-Goals

**Goals:**
- Consolidate all direnv-related code into one module following the three-layer pattern
- Remove direnv code from the nix module (internal + data sync)
- Remove direnv code from the core module (shell hook)
- Keep existing behaviour identical — shell hooks, nix-direnv setup, config sync must all still work

**Non-Goals:**
- Changing how direnv works or its features
- Extracting non-direnv tools from nix beyond the data directory restructure (that can be a separate change)

## Decisions

1. **Target module: devops (`zsh/modules/devops/`)**
   - The guide's reference implementations (atuin, bruno) live in devops following the `DEVOPS_` variable prefix
   - direnv follows the "shell hooks" pattern (like atuin) since it uses `eval "$(direnv hook zsh)"`
   - Using devops avoids creating a new single-tool module and keeps the tool inventory consistent

2. **Module structure follows the guide exactly:**
   ```
   zsh/modules/devops/
   ├── config/direnv.zsh         ← DEVOPS_DIRENV_* variables
   ├── internal/direnv.zsh       ← load, install, upgrade, nix-direnv setup
   ├── pkg/direnv.zsh            ← public API: install, upgrade, sync
   └── data/direnv/              ← direnvrc template for nix-direnv
   ```

   And the nix module data is restructured:
   ```
   zsh/system/nix/data/
   ├── nix/                      ← nix config files (syncs to ~/.config/nix/)
   └── templates/                ← flake templates (unchanged)
   ```

3. **Nix-direnv stays as part of direnv, not nix**
   - nix-direnv is a direnv plugin; its lifecycle (install via nix profile, reference in direnvrc) belongs with direnv
   - The `nix::internal::direnv::setup` function becomes `devops::direnv::internal::nix_direnv::install`

4. **Install method retained: `nix profile install nixpkgs#nix-direnv`**
   - No change to how nix-direnv is installed; only the owning module changes

5. **Config sync moved from nix sync to direnv sync**
   - Currently `nix::internal::config::sync` rsyncs the entire `nix/data/sync/` tree
   - The direnvrc moves to `devops/data/direnv/direnvrc` and a new `devops::direnv::internal::sync` function handles it
   - The nix sync function no longer copies the direnvrc

6. **Nix data directory restructured: `data/nix/` replaces `data/sync/`**
   - The generic `data/sync/` directory is removed (its only content was the direnvrc)
   - A new `data/nix/` directory is created inside the nix module for nix-specific config files
   - `data/nix/` syncs to `~/.config/nix/` (e.g., `nix.conf`)
   - The sync function changes from `rsync data/sync/ $HOME/` to `rsync data/nix/ ~/.config/nix/`

## Risks / Trade-offs

- **Risk: Breaking nix config sync** → The nix sync currently copies the direnvrc along with nix config. Removing the direnvrc from `data/sync/` could break setups that depend on it being synced through nix. **Mitigation:** The new direnv module handles sync independently, so it still happens — just through a different path.
- **Risk: Existing `nix::internal::direnv::setup` callers** → This function is called only in `nix/internal/main.zsh` and has no external callers. **Mitigation:** Low risk; remove the call and source from the new module instead.
- **Trade-off: Splitting direnv concerns across two files** → The core hook (eval) and nix-direnv setup are different concerns but both part of "loading direnv". Keeping them together in one internal file with a unified load function is cleaner than the current split.
