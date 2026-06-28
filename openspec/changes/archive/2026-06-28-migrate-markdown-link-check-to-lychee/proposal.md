## Why

`markdown-link-check` (tcort/markdown-link-check) es un checker secuencial en Node.js que se ha vuelto lento y poco mantenible. `lychee` (lycheeverse/lychee) es un checker asíncrono escrito en Rust, significativamente más rápido, mejor mantenido y ampliamente adoptado. Migrar ahora evita futuros cuellos de botella en CI y pre-commit, y unifica la herramienta de link checking bajo un ecosistema más activo.

## What Changes

- **Remove** `markdown-link-check` hook (repo: `https://github.com/tcort/markdown-link-check`) from `.pre-commit-config.yaml`
- **Add** `lychee` hook (repo: `https://github.com/lycheeverse/lychee`) in `.pre-commit-config.yaml`
- **Add** `lychee` package to `nix/devShell.nix` for Nix-managed environments
- **Create** `.lychee.toml` configuration file, mapping existing rules from `.ci/linters/markdown-link-config.json`:
  - Base URL and replacement patterns
  - Ignore/exclude patterns
  - Timeout, retry, and alive status codes
- **Remove** `.ci/linters/markdown-link-config.json` (no longer needed)
- All existing file exclusion patterns from the current hook must be preserved

## Capabilities

### New Capabilities
- `lychee-link-checker`: Replaces `markdown-link-check` with `lychee` for pre-commit hook and CI link validation. Includes configuration, Nix package dependency, and exclusion patterns.

### Modified Capabilities
- _(none — no existing capability requirements change)_

## Impact

- `.pre-commit-config.yaml`: Remove tcort/markdown-link-check hook, add lycheeverse/lychee hook
- `nix/devShell.nix`: Add `lychee` package
- `.lychee.toml`: New configuration file at repo root (lychee reads from root by default)
- `.ci/linters/markdown-link-config.json`: Delete (replaced by `.lychee.toml`)
- Pre-commit hook args and file exclusion patterns will be re-expressed in lychee terms
