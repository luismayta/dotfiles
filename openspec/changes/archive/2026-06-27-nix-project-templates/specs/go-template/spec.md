## ADDED Requirements

### Requirement: Go project flake template
The system SHALL provide a Nix flake template for Go projects under `data/templates/go/flake.nix`.

The template SHALL include:
- `nixpkgs` input pointing to `nixpkgs-unstable`
- A `devShells.default` with: `go`, `gopls`, `golangci-lint`, `delve`
- Shell hook that sets `CGO_ENABLED=1` and ensures `GOFLAGS` is not set
- A `formatter` output pointing to `nixpkgs-fmt`

#### Scenario: Template creates devShell with Go toolchain
- **WHEN** a user runs `nix::scaffold::new /path --lang go`
- **THEN** the resulting `flake.nix` SHALL contain `go`, `gopls`, and `golangci-lint` in `devShells.default.buildInputs`

#### Scenario: Template builds successfully
- **WHEN** a user runs `nix develop --impure` in a project scaffolded with `--lang go`
- **THEN** `go version` SHALL be available and report the correct version

#### Scenario: Dialect is reproducible
- **WHEN** the template is applied to two different directories
- **THEN** both resulting `flake.nix` files SHALL be identical (same nixpkgs revision, same package set)
