## ADDED Requirements

### Requirement: TypeScript project flake template
The system SHALL provide a Nix flake template for TypeScript projects under `data/templates/typescript/flake.nix`.

The template SHALL include:
- `nixpkgs` input pointing to `nixpkgs-unstable`
- A `devShells.default` with: `nodejs_22`, `bun`, `typescript`, `biome`
- Shell hook that runs `bun install` if `bun.lock` or `package.json` exists
- A `formatter` output pointing to `nixpkgs-fmt`

#### Scenario: Template creates devShell with Node + Bun toolchain
- **WHEN** a user runs `nix::scaffold::new /path --lang typescript`
- **THEN** the resulting `flake.nix` SHALL contain `nodejs_22`, `bun`, and `typescript` in `devShells.default.buildInputs`

#### Scenario: Biome is available as linter/formatter
- **WHEN** a user enters `nix develop` in a project scaffolded with `--lang typescript`
- **THEN** `biome --version` SHALL be available in PATH

#### Scenario: Shell hook runs bun install conditionally
- **WHEN** a `package.json` exists in the project directory
- **THEN** the shell hook SHALL run `bun install` automatically
