## 1. Create Domain Config Files

- [x] 1.1 Create `config/opencode.zsh` with OpenCode variables
- [x] 1.2 Create `config/fabric.zsh` with Fabric variables
- [x] 1.3 Create `config/ollama.zsh` with Ollama variables
- [x] 1.4 Create `config/skills.zsh` with Skills variables and repo arrays
- [x] 1.5 Create `config/graphify.zsh` with Graphify variables
- [x] 1.6 Create `config/openspec.zsh` as placeholder (empty or comment)
- [x] 1.7 Create `config/tools.zsh` with shared tool variables

## 2. Refactor base.zsh

- [x] 2.1 Remove domain-specific variables from `config/base.zsh`
- [x] 2.2 Keep cross-cutting variables (`AI_TOOLS`, `AI_OLLAMA_MODELS`, `AI_INSTALL_URL_*`, `ARCH_NAME`)
- [x] 2.3 Add source lines for all domain config files in dependency order

## 3. Verify

- [x] 3.1 Run `zsh -c 'source config/main.zsh && env | grep AI_'` to verify all variables are exported
- [x] 3.2 Verify no duplicate variable definitions across files
- [x] 3.3 Verify `config/main.zsh` still sources `config/base.zsh` correctly
