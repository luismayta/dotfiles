## Context

Currently, markdown link checking is done via `markdown-link-check` (https://github.com/tcort/markdown-link-check), a Node.js-based hook in `.pre-commit-config.yaml` (lines 103-118). It reads config from `.ci/linters/markdown-link-config.json` and excludes specific file patterns via pre-commit's `exclude` directive.

The tool is synchronous, single-threaded, and has a relatively slow ecosystem (Node.js). `lychee` is a Rust-based async link checker that is 10-100x faster, has a richer configuration model, and is actively maintained by the lycheeverse organization.

This project already uses Nix for dev shell management (`nix/devShell.nix`), so adding `lychee` as a Nix package fits the existing pattern.

## Goals / Non-Goals

**Goals:**
- Replace `markdown-link-check` with `lychee` as the pre-commit link checker
- Preserve all existing exclusion patterns (file-level and URL-level)
- Add `lychee` to the Nix dev shell so it's available system-wide via `nix develop`
- Map all existing config from `.ci/linters/markdown-link-config.json` to `.lychee.toml`
- Maintain the same pre-commit trigger behavior (run on staged `.md` files on `git commit`)

**Non-Goals:**
- Changing which files are checked or not checked beyond the current exclusions
- Adding new link checking capabilities beyond what's currently configured
- Modifying other pre-commit hooks or CI pipelines

## Decisions

### 1. Use `lychee-system` pre-commit hook (system-installed via Nix) over `lychee` (Docker)

- **Decision**: Use the `lychee-system` hook variant, which expects `lychee` binary on `$PATH` (provided by Nix).
- **Rationale**: The project already uses Nix for tooling. The Docker variant would require Docker to be running for pre-commit, adding unnecessary overhead. `lychee` is a single static binary with no runtime dependencies.
- **Alternatives considered**: Using `lychee` (Docker-based) — rejected because it adds Docker dependency and startup latency.

### 2. `.lychee.toml` at `.ci/linters/` (project convention)

- **Decision**: Place `.lychee.toml` at `.ci/linters/.lychee.toml`, following the project convention where all linter configs live in `.ci/linters/`.
- **Rationale**: Every other linter in the project (hadolint, shellcheck, gitleaks, yamllint, etc.) stores its config in `.ci/linters/`. Consistency matters more than lychee's default discovery. The hook args will pass `--config .ci/linters/.lychee.toml` explicitly.
- **Alternatives considered**: Placing it at repo root — rejected because it breaks project convention and scatters config files.

### 3. Mapping `markdown-link-config.json` to `.lychee.toml`

| markdown-link-check | lychee | Notes |
|---|---|---|
| `ignorePatterns[].pattern` | `exclude` (array) | lychee uses regex patterns directly |
| `replacementPatterns[]` | `replace` (array) | lychee's `replace` is `[pattern, replacement]` tuples |
| `timeout: "20s"` | `timeout: 20` | lychee timeout is in seconds |
| `retryOn429: true` | `retry_wait_time` + `max_retries` | lychee retries on any failure by default |
| `retryCount: 3` | `max_retries: 3` | Direct mapping |
| `fallbackRetryDelay: "30s"` | `retry_wait_time: 30` | lychee wait time in seconds |
| `aliveStatusCodes` | `accept` (array) | lychee uses `accept` for acceptable status codes |

### 4. File exclusion patterns move from pre-commit `exclude` to lychee `exclude_path`

- **Decision**: Move the file-level exclusion patterns from `.pre-commit-config.yaml`'s `exclude` field into `.lychee.toml`'s `exclude_path` array.
- **Rationale**: Keeps all link-checking exclusion logic in one place. The pre-commit `exclude` field is still useful but redundant once lychee has its own path exclusions.
- **Exception**: We keep the pre-commit `exclude` for files that lychee shouldn't even be invoked on (e.g., binary files) to avoid unnecessary process spawns.

## Risks / Trade-offs

- **Exclusion pattern fidelity**: lychee regex syntax may differ slightly from the pre-commit Python regex engine. Patterns must be manually verified after migration.
  - **Mitigation**: Run `lychee --config .lychee.toml .` and compare results with the existing hook output.
- **retry-wait-time units**: lychee uses seconds (integer), markdown-link-check uses Go duration strings ("30s"). Ensure correct conversion.
- **Behavior change**: lychee may detect different links than markdown-link-check (e.g., in code blocks, HTML attributes). Some links that were previously skipped may now be checked.
  - **Mitigation**: Review lychee's output on a full repo scan before removing the old hook.
