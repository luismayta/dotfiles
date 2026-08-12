## 1. Scaffold module files

- [ ] 1.1 Create `zsh/modules/devops/config/cloudflared.zsh` (registration/exports)
- [ ] 1.2 Create `zsh/modules/devops/internal/cloudflared.zsh` (helper functions)
- [ ] 1.3 Create `zsh/modules/devops/pkg/cloudflared.zsh` (install + availability check)
- [ ] 1.4 Register `cloudflared` in the three `main.zsh` files and add it to `DEVOPS_TOOLS` in `config/base.zsh`

## 2. Implement install (pkg)

- [ ] 2.1 Implement idempotent availability check (`core::exists` style)
- [ ] 2.2 Implement binary download to `/usr/local/bin` with checksum verification
- [ ] 2.3 Implement apt-repo fallback path

## 3. Implement helpers (internal)

- [ ] 3.1 `cloudflared_login` wrapper around `cloudflared tunnel login`
- [ ] 3.2 `cloudflared_create` wrapper around `cloudflared tunnel create`
- [ ] 3.3 `cloudflared_route_dns` wrapper around `cloudflared tunnel route dns`
- [ ] 3.4 `cloudflared_quick` wrapper around `cloudflared tunnel --url`

## 4. Document

- [ ] 4.1 Add usage notes and the local-HTTPS-exposure use case to the module docs
- [ ] 4.2 Cross-link the Codip runbook example (`runbook-meta-developer.md`)

## 5. Validate

- [ ] 5.1 Run `openspec validate` on the change
- [ ] 5.2 Run `shellcheck` on the new zsh files
