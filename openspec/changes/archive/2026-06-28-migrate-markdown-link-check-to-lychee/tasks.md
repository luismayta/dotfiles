## 1. Nix Dependency

- [x] 1.1 Add `lychee` package to `nix/devShell.nix` in the "Linters & formatters" section

## 2. Lychee Configuration

- [x] 2.1 Create `.ci/linters/.lychee.toml` with all mapped config
- [x] 2.2 Add `exclude_path` patterns in `.lychee.toml` matching the pre-commit file exclusion list

## 3. Pre-commit Hook Migration

- [x] 3.1 Remove the `markdown-link-check` hook block from `.pre-commit-config.yaml`
- [x] 3.2 Add the `lychee` hook with `lychee-system` id, `rev: lychee-v0.24.2`, and args `--config .ci/linters/.lychee.toml --no-progress` in `.pre-commit-config.yaml`
- [x] 3.3 Remove `.ci/linters/markdown-link-config.json` (no longer needed)

## 4. Verification

- [x] 4.1 Run `nix-shell -p lychee` to confirm `lychee --version` = `lychee 0.24.2`
- [x] 4.2 Run `pre-commit run lychee-system --files README.md` to verify the hook works (Passed)
- [x] 4.3 Run `lychee --config .ci/linters/.lychee.toml --offline README.md` - 0 errors, config valid
- [x] 4.4 Remove old config file `.ci/linters/markdown-link-config.json` - deleted
