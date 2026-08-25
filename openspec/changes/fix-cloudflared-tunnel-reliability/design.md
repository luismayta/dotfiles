## Context

The `devops::cloudflared::internal::tunnel::create` function in `zsh/modules/devops/internal/cloudflared.zsh` is a 137-line zsh function that provisions Cloudflare tunnels. It currently uses fragile text parsing for UUID lookup, never updates existing configs, uses a deprecated `url:` directive, doesn't check DNS idempotency, and has no port validation. The function is the single entry point for tunnel creation in this dotfiles setup.

## Goals / Non-Goals

**Goals:**
- Replace all fragile text parsing with structured JSON output (`cloudflared tunnel list --format json` + `jq`)
- Make config generation idempotent — update when values change, skip when stable
- Modernize config format to use `ingress:` exclusively
- Add DNS idempotency check
- Add port availability warning (non-blocking)
- Maintain full backward compatibility with existing tunnels

**Non-Goals:**
- Refactoring the module structure (pkg/internal/config split stays as-is)
- Adding tunnel deletion or listing commands
- Changing the public API signature of `devops::cloudflared::tunnel::create`
- Modifying the config directory layout or credential file paths

## Decisions

### D1: Use `jq` for JSON parsing

**Decision:** Parse `cloudflared tunnel list --format json` with `jq` instead of `sed`/`awk`/`grep`.

**Rationale:** `jq` is the standard tool for JSON in shell scripts. The `--format json` flag is documented Cloudflare CLI behavior. `jq` handles edge cases (tunnel names with spaces, unicode) that regex parsing misses.

**Alternatives considered:**
- `python -c`: Heavier dependency, slower startup
- `grep`/`awk` on JSON: Fragile, same problem as current approach
- `cloudflared tunnel list` without `--format`: Still produces tabular output, no improvement

**Prerequisite:** `jq` must be available on PATH. The devops module already depends on common CLI tools; `jq` is a reasonable addition. If `jq` is missing, fall back to the current `tail | awk` approach with a warning.

### D2: Config comparison before rewrite

**Decision:** Read existing config.yml, extract current `tunnel:`, `hostname:`, and `service:` values, and compare against provided parameters before writing.

**Rationale:** Avoids unnecessary file rewrites that could trigger file watchers or lose manual edits. Only rewrite when something actually changed.

**Implementation:** Use `grep` to extract the relevant lines from config.yml and compare against expected values. This is simpler than parsing full YAML in zsh.

### D3: DNS check via tunnel route list

**Decision:** Check if DNS is already routed by parsing `cloudflared tunnel route dns` output or using `dig`/`nslookup` to verify the CNAME record exists.

**Rationale:** `cloudflared tunnel route dns` is idempotent but emits an error if already routed, which looks like a failure. Checking first provides cleaner output.

**Alternatives considered:**
- Just call `cloudflared tunnel route dns` and ignore the error: Simpler but noisy
- Use Cloudflare API: Requires auth tokens, overkill for a zsh helper

### D4: Port check as non-blocking warning

**Decision:** Verify port availability with `nc -z` or `ss -tln` and warn if in use, but do not abort.

**Rationale:** The port may not be in use at configuration time but will be at tunnel run time (e.g., the service starts later). Blocking would be overly restrictive for a helper function. A warning gives the user visibility without preventing operation.

## Risks / Trade-offs

- **[Risk] `jq` not installed** → Mitigation: Check for `jq` at function entry; fall back to `tail | awk` with a deprecation warning if missing. Log a message suggesting `jq` installation.
- **[Risk] Config comparison using grep may miss edge cases** → Mitigation: Use simple string matching on known keys (`tunnel:`, `hostname:`, `service:`). These are stable YAML keys in cloudflared configs.
- **[Risk] DNS check may produce false negatives** → Mitigation: If the check fails or is ambiguous, proceed with routing (safe default — `cloudflared tunnel route dns` handles duplicates gracefully).
- **[Trade-off] Port check is advisory only** → Acceptable because tunnel creation is a config operation, not runtime binding. The user controls when `cloudflared tunnel run` executes.
