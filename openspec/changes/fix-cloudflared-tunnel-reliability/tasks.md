## 1. Pre-flight and UUID Resolution

- [x] 1.1 Add `jq` availability check at function entry; fall back to `tail | awk` with deprecation warning if `jq` is missing
- [x] 1.2 Replace fragile `tail | awk` UUID parsing (lines 85, 93) with `cloudflared tunnel list --format json | jq -r '.[] | select(.name=="<name>") | .id'`
- [x] 1.3 Add helper function `devops::cloudflared::internal::tunnel::resolve_uuid` to encapsulate JSON-based UUID resolution (called at both lookup points)

## 2. Port Validation

- [x] 2.1 Add port availability check using `nc -z localhost <port>` (with `ss -tln` fallback for systems without `nc`)
- [x] 2.2 Display non-blocking warning if port is already in use (proceed with creation, do not abort)

## 3. Config Generation — Idempotent and Modern

- [x] 3.1 Replace `[[ ! -f "${config_file}" ]]` guard with config comparison logic: read existing `tunnel:`, `hostname:`, and `service:` values via `grep`
- [x] 3.2 Only rewrite config.yml when hostname or port differ from existing values
- [x] 3.3 Replace deprecated `url:` directive (lines 126–130) with `ingress:` format for no-hostname case: `- service: http://localhost:<port>` + `- service: http_status:404`
- [x] 3.4 Ensure hostname case also uses `ingress:` format (already correct, verify no regression)

## 4. DNS Idempotency

- [x] 4.1 Add DNS routing check: parse `cloudflared tunnel route dns` output or use `dig` to verify if hostname CNAME already points to the tunnel
- [x] 4.2 Skip `cloudflared tunnel route dns` call when already routed; log "DNS already configured for <hostname>"
- [x] 4.3 Proceed with routing when check is ambiguous or fails (safe default)

## 5. Verification

- [ ] 5.1 Test: create new tunnel with hostname — verify UUID resolved via JSON, config uses `ingress:`, DNS routed
- [ ] 5.2 Test: re-run with same parameters — verify no config rewrite, no DNS re-route
- [ ] 5.3 Test: re-run with changed port — verify config updated, DNS skipped
- [ ] 5.4 Test: create tunnel without hostname — verify config uses `ingress:` (no `url:`), catch-all rule present
- [ ] 5.5 Test: port already in use — verify warning displayed but creation proceeds
