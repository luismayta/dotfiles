# Task: Optimizar performance de arranque de zsh y bin/jasper::reload

## Issue Metadata

- projectKey: PE
- issueType: Task
- summary: Reducir el tiempo de arranque de zsh y la recarga de bin/jasper::reload en los dotfiles
- component: DevOps
- labels: [improvement, devops]
- parentEpic: 
- issueKey: PE-681
- jpdSource: NIP-23

## Scenario

El arranque de cada shell interactiva en los dotfiles costaba ~4.1 s en caliente, y `bin/jasper::reload` cargaba el framework core completo solo para ejecutar `exec $SHELL`. El mayor culpable era la regeneración de `gcloud completion zsh` en cada arranque (~2.4 s, 59% del tiempo) con un comando inválido en el SDK 574.0.0, seguido del thrash de compinit (dos invocaciones con fpath inconsistente, ~690 ms), rsync incondicionales de mpd/ncmpcpp, docker health check eager, y gh completions fallando en cada arranque. Se ejecutó una ronda de optimización: cacheo de completions (gcloud vía completion.zsh.inc del SDK, kubectl), compinit único con dump congelado (freshness 24 h + `compinit -C`), guardas mtime en syncs, eliminación de trabajo eager, fix de `bin/jasper::reload` (sourcea solo `reload.zsh`), dedup de PATH/FPATH (`core::path::clean` + `typeset -U`), merge de los archivos vivos `~/.zshrc`/`~/.zshenv` con el repo (con backups), hardening (mktemp en el cache de completions, frescura de dump con fix de cambio de año) y una pasada de simplify con A/B de equivalencia. Resultado: ~4.1 s → ~0.85–1.17 s (3.5–4× más rápido), verificado con suites de test y medición en shells reales.

### Acceptance Tests

1. `zsh -i -c exit` en caliente ≤ 1.2 s (baseline era ~4.1 s)
2. El completion de gcloud se sirve desde cache sin invocar `gcloud` en cada arranque (mtime del cache congelado entre runs)
3. `.zcompdump` no se reescribe en arranques consecutivos (mtime congelado) y `${#_comps}` > 0 con `_gcloud`, `_git`, `_gh` definidos
4. PATH y FPATH sin entradas duplicadas (`print -l $PATH | sort | uniq -d` vacío)
5. Suites de test en verde: gcloud-completion 29/29, completion-cache 14/14, gh-completions 19/19, mpd-sync 9/9, docker-defer 7/7
6. Hook pre-commit `bin-zsh-syntax-check` pasa con `zsh -n` sobre `bin/*` y detecta errores (test negativo probado)
7. `~/.zshrc` y `~/.zshenv` byte-idénticos a `zsh/zshrc`/`zsh/zshenv` del repo, con backups `*.premerge-*` y `*.presimplify-*` verificados con `cmp`
8. `ZSH_DEBUG=1 zsh -i -c exit` imprime la tabla zprof (observabilidad funcionando)
9. `bin/jasper::reload` sourcea solo `zsh/system/core/internal/reload.zsh` (script ~4 ms)

### Sources


- https://github.com/luismayta/dotfiles.git