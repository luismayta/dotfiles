## 1. Environment & Config

- [ ] 1.1 Add `MEM0_API_KEY` env var to `config/base.zsh`
- [ ] 1.2 Add mem0 MCP server entry (disabled) to `data/opencode/opencode.json` under `"mcp"` key

## 2. Internal Module

- [ ] 2.1 Create `internal/mem0.zsh` with `ai::internal::mem0::load` function (PATH loader)
- [ ] 2.2 Add `ai::internal::mem0::install` function (pip/uv install mem0ai, idempotent)
- [ ] 2.3 Source `internal/mem0.zsh` in `internal/main.zsh`

## 3. Public API

- [ ] 3.1 Create `pkg/mem0.zsh` with `ai::mem0::install` (delegates to internal)
- [ ] 3.2 Add `ai::mem0::key::check` function (reports MEM0_API_KEY status)
- [ ] 3.3 Add `ai::mem0::key::setup` function (runs `mem0 init --agent`)
- [ ] 3.4 Add `ai::mem0::key::validate` function (checks `m0-` prefix)
- [ ] 3.5 Source `pkg/mem0.zsh` in `pkg/main.zsh`

## 4. Sync Integration

- [ ] 4.1 Add mem0 config sync to `ai::sync` in `pkg/tools.zsh` (if config propagation needed)

## 5. Verification

- [ ] 5.1 Verify `ai::mem0::install` is idempotent (runs twice without error)
- [ ] 5.2 Verify `ai::mem0::key::check` reports correct status with/without key
- [ ] 5.3 Verify `ai::sync` propagates mem0 MCP entry to opencode.json
