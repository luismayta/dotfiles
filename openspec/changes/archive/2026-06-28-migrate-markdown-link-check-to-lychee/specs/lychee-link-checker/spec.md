## ADDED Requirements

### Requirement: lychee replaces markdown-link-check as pre-commit link checker

The system SHALL use `lychee` from `lycheeverse/lychee` as the markdown link checker in pre-commit, replacing `markdown-link-check` from `tcort/markdown-link-check`.

#### Scenario: lychee hook runs on pre-commit
- **WHEN** `git commit` is executed with staged `.md` files
- **THEN** the lychee pre-commit hook SHALL run and check links in staged files
- **AND** the old `markdown-link-check` hook SHALL NOT be present in `.pre-commit-config.yaml`

### Requirement: lychee is available via Nix dev shell

The system SHALL include `lychee` as a package in `nix/devShell.nix` so it is available on `$PATH` when using `nix develop`.

#### Scenario: lychee binary is available in Nix shell
- **WHEN** `nix develop` is executed
- **THEN** `lychee --version` SHALL return a version string without error

### Requirement: lychee configuration preserves existing behavior

The `.ci/linters/.lychee.toml` configuration SHALL preserve all exclusion patterns, replacement rules, timeout, retry, and status code behavior from the existing `.ci/linters/markdown-link-config.json`.

#### Scenario: base URL replacement works
- **WHEN** lychee encounters a relative URL starting with `/docs` or `/`
- **THEN** it SHALL replace it with the configured base URL `https://github.com/luismayta/dotfiles` before checking

#### Scenario: mailto patterns are excluded
- **WHEN** lychee encounters a URL matching `mailto:*@hadenlabs.com`
- **THEN** it SHALL skip (not check) that URL

#### Scenario: localhost URLs are excluded
- **WHEN** lychee encounters a URL starting with `http://localhost`
- **THEN** it SHALL skip (not check) that URL

#### Scenario: relative data paths are excluded
- **WHEN** lychee encounters a URL matching `../data/opencode/commands/`
- **THEN** it SHALL skip (not check) that URL

#### Scenario: timeout is set to 20 seconds
- **WHEN** lychee checks a URL
- **THEN** it SHALL timeout after 20 seconds per request

#### Scenario: retry on failure with backoff
- **WHEN** a URL returns a 429 status or fails transiently
- **THEN** lychee SHALL retry up to 3 times with a 30-second wait between retries

#### Scenario: accepted status codes include 2xx and 206
- **WHEN** lychee receives HTTP status 200, 201, 202, or 206
- **THEN** it SHALL consider the link valid

### Requirement: file-level exclusion patterns are preserved

Files matching the existing exclusion patterns SHALL NOT be checked by lychee.

#### Scenario: templated markdown files are excluded
- **WHEN** lychee scans a file matching `*.tpl.md` or `docs/env-vars.md`
- **THEN** it SHALL skip that file

#### Scenario: data pattern files are excluded
- **WHEN** lychee scans a file under `data/patterns/`
- **THEN** it SHALL skip that file

#### Scenario: openspec command docs are excluded
- **WHEN** lychee scans a file under `docs/opencode/commands/`
- **THEN** it SHALL skip that file

#### Scenario: terraform include is excluded
- **WHEN** lychee scans `docs/include/terraform.md`
- **THEN** it SHALL skip that file
