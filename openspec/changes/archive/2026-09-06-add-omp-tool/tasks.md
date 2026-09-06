## 1. Config Layer

- [x] 1.1 Create `zsh/modules/ai/config/omp.zsh` exporting `ZSH_AI_OMP_BIN_PATH`, `ZSH_AI_OMP_CONFIG_PATH` (`~/.omp/agent`), `ZSH_AI_OMP_CONFIG_SOURCE_PATH` (`$ZSH_AI_PATH/data/omp`), `ZSH_AI_OMP_INSTALL_URL` (`https://omp.sh/install`) — mirror `config/pi.zsh`
- [x] 1.2 Create `zsh/modules/ai/data/omp/` directory (with `.gitkeep`) as config sync source
- [x] 1.3 Add `source "${ZSH_AI_PATH}/config/omp.zsh"` in `zsh/modules/ai/config/base.zsh` adjacent to `config/pi.zsh`
- [x] 1.4 Add `omp` to the `ZSH_AI_TOOLS` array in `zsh/modules/ai/config/base.zsh`

## 2. Internal Layer

- [x] 2.1 Create `zsh/modules/ai/internal/omp.zsh` with `ai::internal::omp::load` (prepend `ZSH_AI_OMP_BIN_PATH` to PATH when omp binary exists, silent return otherwise) — mirror `internal/pi.zsh`
- [x] 2.2 Add `ai::internal::omp::install` with `core::exists omp` guard (early return 0), `curl -fsSL "${ZSH_AI_OMP_INSTALL_URL}" | sh`, success/error messages
- [x] 2.3 Add `ai::internal::omp::config::sync` (mkdir -p target, `rsync -a` from `ZSH_AI_OMP_CONFIG_SOURCE_PATH` to `ZSH_AI_OMP_CONFIG_PATH`, warning if source missing)
- [x] 2.4 Add `source "${ZSH_AI_PATH}/internal/omp.zsh"` in `zsh/modules/ai/internal/main.zsh` adjacent to `internal/pi.zsh`
- [x] 2.5 Invoke `ai::internal::omp::load` in the "Load paths" block of `zsh/modules/ai/internal/main.zsh` next to `ai::internal::pi::load`

## 3. Public Layer

- [x] 3.1 Create `zsh/modules/ai/pkg/omp.zsh` with public functions `ai::omp::install` and `ai::omp::config::sync` delegating to internal — mirror `pkg/pi.zsh`
- [x] 3.2 Add `source "${ZSH_AI_PATH}/pkg/omp.zsh"` in `zsh/modules/ai/pkg/main.zsh` adjacent to `pkg/pi.zsh`

## 4. Verification

- [x] 4.1 Module loads without errors: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh`
- [x] 4.2 `type ai::omp::install` returns `function`
- [x] 4.3 `type ai::omp::config::sync` returns `function`
- [x] 4.4 `omp` present in `ZSH_AI_TOOLS` array after config layer loads
- [x] 4.5 `ai::internal::omp::load` returns silently when omp binary absent (no PATH modification)