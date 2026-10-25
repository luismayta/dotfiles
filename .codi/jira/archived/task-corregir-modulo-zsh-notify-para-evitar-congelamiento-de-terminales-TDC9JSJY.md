# Task: Corregir módulo zsh notify para evitar congelamiento de terminales

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Corregir notify: play() no bloqueante y segura para el terminal, sin instalación en arranque y con pruebas bats.
- component: Notifications
- labels: []
- parentEpic: 
- issueKey: RD-256
- jpdSource: 

## Scenario

Los terminales Ghostty y WezTerm en CachyOS/Hyprland se congelan de forma intermitente desde una actualización de sistema. La auditoría del módulo zsh `notify` (`zsh/modules/notify/`) confirmó la causa en el código: `notify::internal::play` (`internal/base.zsh:43-45`) ejecuta `mpg123` en primer plano dentro del hook `precmd`, sin timeout, sin redirigir `stdin` y con control de terminal activo.

Evidencia en runtime: varios procesos `mpg123` bloqueados en `futex_wait` más de 70 minutos sobre archivos de 1.56 segundos; la shell padre esperando en `rt_sigsuspend` con `TPGID` del hijo, por lo que el prompt nunca se dibuja y la pestaña queda muerta. Tres procesos eran huérfanos (`PPID=1`, `fd0` sobre un pty destruido) que sobrevivieron al cerrar la pestaña, acumulándose uno por tab perdido. `mpg123` captura `SIGTERM`/`SIGINT` pero no actúa sobre ellas mientras está bloqueado, por lo que un `timeout` basado en `SIGTERM` no termina el proceso y hace falta `SIGKILL`.

Contención ya aplicada fuera de este alcance: `notify` añadido a `ZSH_DISABLED_MODULES` en `~/.customrc` y `kill -9` de los seis procesos colgados verificados. Esta task entrega la corrección permanente para que el módulo pueda reactivarse sin riesgo de congelar terminales.


### Acceptance Tests

- `notify::internal::play` verifica la existencia del binario `mpg123` y retorna 0 sin ejecutar nada si no existe.
- `notify::internal::play` invoca `mpg123` con `--no-control` y `-q`, con `stdin` redirigido desde `/dev/null` (nunca el tty), en segundo plano desasociado, y retorna siempre 0 para no truncar la cadena de hooks `precmd`.
- La reproducción está acotada a 8 s con respaldo `SIGKILL` de 2 s (`timeout -k`), de modo que un proceso que ignora `SIGTERM` termina igual.
- Existe un guard de instancia única: si ya corre un `mpg123`, la llamada se descarta y no se acumulan reproducciones.
- `internal/main.zsh:50` y `:54` ya no llaman `core::ensure`; el arranque de la shell nunca invoca instalación de paquetes.
- `internal/base.zsh:7` usa `[[ ... -regex-match ... ]]` y la lista de omisión sigue filtrando `ssh|vim|nvim|tmux|...`.
- Los adaptadores `noti` y `notify-send` están acotados con `timeout` y respaldo `SIGKILL`; uno lento no bloquea el prompt.
- `internal/base.zsh:12` y `:22` usan `EPOCHSECONDS` en lugar de `$(date +%s)`; sin forks de `date` por prompt.
- Existe `zsh/modules/notify/tests/` con pruebas bats bajo `zsh -f` y una tarea `test` en el `Taskfile.yml` del módulo (convención del módulo `herdr`).
- Cobertura de regresión: retorno en <1 s ante un `mpg123` que tarda 30 s; flags `--no-control`/`-q` presentes y `stdin` no es tty; muerte por `SIGKILL` ante `trap '' TERM`; `icanon`/`echo` conservados tras la llamada; el hook siguiente se ejecuta cuando `mpg123` retorna ≠0; `$?` capturado a través del wrapper; sin notificación en `timediff == 10`; un único registro del hook tras cargar `plugin.zsh` dos veces; sin hooks con `ZSH_DISABLED_MODULES=notify`.
- Regresión verificable: ninguna shell queda bloqueada en `rt_sigsuspend` por una notificación, y no sobreviven procesos `mpg123` huérfanos tras cerrar una pestaña.


### Sources

- Repositorio: https://github.com/luismayta/dotfiles
- Auditoría interna del módulo: `zsh/modules/notify/` (`plugin.zsh`, `internal/base.zsh`, `internal/main.zsh`, `pkg/base.zsh`, `config/base.zsh`, `internal/adapter/noti.zsh`, `internal/adapter/notify-send.zsh`)
- Punto de fallo principal: `zsh/modules/notify/internal/base.zsh:43-45`
- Registro de hooks: `zsh/modules/notify/internal/main.zsh:58-60`
- Mecanismo de desactivación: `zsh/zshrc:57-67` (`ZSH_DISABLED_MODULES`)
- Convención de pruebas existente: `zsh/modules/herdr/tests/`

- https://github.com/luismayta/dotfiles.git