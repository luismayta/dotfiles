## Why

The `nix::scaffold::init` function currently creates a bare-minimum flake.nix with no language-specific tooling. Projects in different languages need different packages, build tooling, and dev environments. Adding per-language templates makes the scaffold useful for real projects instead of just a skeleton.

## What Changes

- Add named templates to `zsh/modules/nix/data/templates/` for Go, Python, TypeScript, and Rust
- Each template includes a `flake.nix` with the standard toolchain and packages for that language
- Add per-language scaffold commands: `nix::scaffold::go`, `nix::scaffold::python`, `nix::scaffold::typescript`, `nix::scaffold::rust`
- Keep the current bare template as `default` when no language is specified

## Capabilities

### New Capabilities

- `go-template`: Nix flake template for Go projects (go, gopls, golangci-lint, delve)
- `python-template`: Nix flake template for Python projects (python, uv/poetry, ruff, mypy)
- `typescript-template`: Nix flake template for TypeScript projects (node, bun/pnpm, typescript, biome)
- `rust-template`: Nix flake template for Rust projects (rustc, cargo, clippy, rust-analyzer)

### Modified Capabilities

- *None.*

## Impact

- `zsh/modules/nix/pkg/scaffold.zsh` — adds `nix::scaffold::go`, `nix::scaffold::python`, `nix::scaffold::typescript`, `nix::scaffold::rust` functions
- `zsh/modules/nix/data/templates/` — adds 4 new template directories: `go/`, `python/`, `typescript/`, `rust/`
- Existing `nix::scaffold::init` behavior is unchanged (defaults to bare template)
