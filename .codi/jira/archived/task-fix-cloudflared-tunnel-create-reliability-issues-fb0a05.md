# Task: Fix cloudflared tunnel create function reliability issues

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Fix fragile UUID parsing, config update, deprecated url directive, DNS idempotency, and service validation
- component: DevOps
- labels: [cloudflared, zsh, devops]
- parentEpic: RD-30
- issueKey: RD-125
- jpdSource: 

## Scenario

The cloudflared tunnel create function in zsh/modules/devops has several reliability issues that can cause silent failures or incorrect configurations:

1. UUID lookup uses fragile tail/awk parsing of `cloudflared tunnel list` output instead of --format json
2. Config file (config.yml) is never updated on re-run, even if hostname or port changes
3. No-hostname config uses deprecated `url:` directive instead of modern `ingress:` format
4. DNS routing does not check if already routed before attempting
5. No validation that the target port is actually listening before tunnel creation

### Acceptance Tests

- [ ] UUID lookup uses `cloudflared tunnel list --format json` instead of fragile tail/awk parsing
- [ ] Config file is updated when hostname or port changes on re-run (not just scaffolded if missing)
- [ ] No-hostname config uses `ingress:` format instead of deprecated `url:` directive
- [ ] DNS routing checks if already routed before attempting `cloudflared tunnel route dns`
- [ ] Port availability is verified (e.g. via nc or ss) before tunnel creation
- [ ] All changes maintain backward compatibility with existing tunnel configurations

### Sources

- https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/

- https://github.com/luismayta/dotfiles.git
