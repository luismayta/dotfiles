## 1. Template Files

- [x] 1.1 Create `zsh/modules/nix/data/templates/go/flake.nix` with Go toolchain (go, gopls, golangci-lint, delve)
- [x] 1.2 Create `zsh/modules/nix/data/templates/python/flake.nix` with Python toolchain (python3, uv, ruff, mypy)
- [x] 1.3 Create `zsh/modules/nix/data/templates/typescript/flake.nix` with TypeScript toolchain (nodejs_22, bun, typescript, biome)
- [x] 1.4 Create `zsh/modules/nix/data/templates/rust/flake.nix` with Rust toolchain (cargo, rustc, clippy, rust-analyzer, rustfmt)

## 2. Scaffold Functions

- [x] 2.1 Create shared internal function `nix::scaffold::_from_template` that copies a template dir into `$PWD`
- [x] 2.2 Add `nix::scaffold::go` — scaffolds `data/templates/go/` into `$PWD`
- [x] 2.3 Add `nix::scaffold::python` — scaffolds `data/templates/python/` into `$PWD`
- [x] 2.4 Add `nix::scaffold::typescript` — scaffolds `data/templates/typescript/` into `$PWD`
- [x] 2.5 Add `nix::scaffold::rust` — scaffolds `data/templates/rust/` into `$PWD`
- [x] 2.6 Ensure idempotency: do not overwrite existing `flake.nix` or `nix/` directory

## 3. Verification

- [x] 3.1 `cd /tmp/test-nix-go && nix::scaffold::go && ls flake.nix nix/`
- [x] 3.2 `cd /tmp/test-nix-py && nix::scaffold::python && ls flake.nix nix/`
- [x] 3.3 `cd /tmp/test-nix-ts && nix::scaffold::typescript && ls flake.nix nix/`
- [x] 3.4 `cd /tmp/test-nix-rs && nix::scaffold::rust && ls flake.nix nix/`
- [x] 3.5 `cd /tmp/test-nix-bare && nix::scaffold::init && ls flake.nix nix/`
