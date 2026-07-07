## 1. Config sync — migrar a rsync

- [ ] 1.1 Crear `ai::internal::hunk::config::sync` en `internal/base.zsh` con rsync + guard `core::exists rsync`
- [ ] 1.2 Refactorizar `ai::hunk::config::sync` en `pkg/helper.zsh` para delegar en `ai::internal::hunk::config::sync`
- [ ] 1.3 Verificar que `ai::sync` en `pkg/helper.zsh` sigue llamando a `ai::hunk::config::sync` correctamente

## 2. Daemon lifecycle — stop, status, restart

- [ ] 2.1 Implementar `ai::hunk::daemon::stop` en `pkg/helper.zsh` — lee PID de `/tmp/hunk-daemon.pid`, mata proceso, limpia archivo
- [ ] 2.2 Implementar `ai::hunk::daemon::status` en `pkg/helper.zsh` — verifica PID file + proceso activo
- [ ] 2.3 Implementar `ai::hunk::daemon::restart` en `pkg/helper.zsh` — stop + start
- [ ] 2.4 Actualizar `ai::hunk::daemon::start` para persistir PID en `/tmp/hunk-daemon.pid`
- [ ] 2.5 Implementar `ai::hunk::session::list` en `pkg/helper.zsh` — ejecuta `hunk session list`

## 3. Agent skill integration

- [ ] 3.1 Implementar `ai::hunk::skill::path` en `pkg/helper.zsh` — ejecuta `hunk skill path` y retorna el path
- [ ] 3.2 Actualizar `data/opencode/commands/hadx-review.md` con documentación del skill path, manejo de errores, y ciclo de vida del daemon

## 4. Config template — completar campos faltantes

- [ ] 4.1 Actualizar `data/hunk/config.toml` con campos: `mode`, `vcs`, `watch`, `exclude_untracked`

## 5. Correcciones menores

- [ ] 5.1 Corregir comentario en `zsh/modules/zed/data/keymap.json` — cambiar "Git Hunks" por descripción precisa

## 6. Aliases — agregar nuevos comandos

- [ ] 6.1 Agregar alias `hunk-daemon-status`, `hunk-daemon-stop`, `hunk-daemon-restart` en `pkg/alias.zsh`
- [ ] 6.2 Agregar alias `hunk-skill-path` y `hunk-session-list` en `pkg/alias.zsh`

## 7. Git module integration — hunk como visor de diff

- [ ] 7.1 Crear función `git::hunk::diff` en `pkg/base.zsh` del módulo git que ejecute `hunk diff` para revisar cambios del working tree
- [ ] 7.2 Crear función `git::hunk::show` en `pkg/base.zsh` del módulo git que ejecute `hunk show` para revisar commits
- [ ] 7.3 Agregar alias `ghd` (git hunk diff) y `ghs` (git hunk show) en `pkg/alias.zsh` del módulo git
- [ ] 7.4 Agregar sección comentada en `data/sync/.gitconfig` documentando `core.pager = "hunk pager"` como alternativa a delta
