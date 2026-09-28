## Context

Este documento cubre el **scaffold y las decisiones de diseño** del módulo. La motivación vive en `proposal.md`; el contrato de comportamiento vive en `specs/osx-module/spec.md` y no se duplica acá. Lo que sigue es el trabajo de diseño que quedó fuera del proposal: cómo se corta el código, cómo se modelan las operaciones que no se ejecutan, y qué se descartó.

El cambio es puramente aditivo. No modifica ningún módulo existente, no altera comportamiento en Linux ni en macOS, y no tiene sección `BREAKING`.

Tres restricciones del entorno condicionan buena parte de lo que sigue:

1. **El residuo es chico a propósito.** `darwin-system-config` (cambio activo `nix-darwin-support`) es dueño de los ~150 defaults declarativos de dominio de usuario. Este módulo solo cubre escrituras host-scoped, operaciones privilegiadas degradadas, operaciones destructivas gateadas, refresco en runtime y el reporte de drift de screen-lock. La consecuencia directa es que el scaffold del ticket (14 archivos de área) describe un módulo que ya no existe.

2. **La guía es un mínimo, no un techo.** `docs/guides/create-module.md:738-757` lista 18 ítems de scaffold, pero ninguno de los módulos de referencia se detiene ahí: `zed` tiene 22 entradas y `apps` tiene 20. El checklist marca explícitamente seis archivos como *"(optional, only if needed)"*. Diseñar contra el 18 literal produce un módulo peor, no más conforme.

3. **El repo tiene trampas concretas** que un implementador copia sin pensar y que este design tiene que cerrar explícitamente: un bug de render vacío en `zed`, un helper de core que no falla, y un caché de existencia de binarios.

## Goals / Non-Goals

Estos son límites de diseño, no de alcance (el alcance ya está en el proposal).

**Goals de diseño:**

- Que el número de archivos de `internal/` refleje el residuo real, no el residuo imaginario.
- Que las 12 operaciones privilegiadas sean **datos**, no código: una fila por operación, y un renderer que itera.
- Que toda operación destructiva sea inalcanzable sin un opt-in explícito, y que el mecanismo de gate sea predecible (un flag en `false` nunca dispara nada).
- Que el refresco en runtime sea siempre explícito y siempre pedido por el usuario.
- Que la superficie pública sea mínima y ortogonal, sin stubs ni duplicación de otros módulos.
- Que el inventario de migración quede como artefacto legible por máquina, versionado junto al código que lo produce.

**Non-Goals de diseño:**

- No se generaliza infraestructura compartida. `core::confirm` no se agrega; la lógica de confirmación se queda en el módulo.
- No se modela "el módulo de macOS" en abstracto. El módulo no es extensible por diseño; agregar una capacidad futura es un cambio acotado, no una infraestructura nueva.
- No se replica la técnica de ningún módulo en detalle. Se replica forma, no contenido.
- No se persisten, cachean ni sincronizan estado entre invocaciones. El módulo es stateless: lee, escribe, reporta.

## Decisions

### D1. `internal/` se parte en 5 archivos de área, no en 14

**Elegido.** `internal/` queda así:

| Archivo | Responsabilidad | Origen en el source |
|---|---|---|
| `internal/main.zsh` | Sourcea los 5 archivos de área, en orden fijo. Sin dispatch de OS. | — |
| `internal/host.zsh` | Escrituras `defaults -currentHost write`. | `base.zsh:45,161,167,168,172,510` |
| `internal/privileged.zsh` | Tabla `ZSH_OSX_PRIVILEGED_OPS` + renderer. | `base.zsh:363-368,482,488,498-501` |
| `internal/destructive.zsh` | Helper `_osx::confirm` + las 2 operaciones. | `base.zsh:38,320-323` |
| `internal/refresh.zsh` | `killall Finder` / `killall Dock`. | `base.zsh:306,412` |
| `internal/screenlock.zsh` | Detección de drift + ruta soportada. | `base.zsh:183,184,353,354` |

**Por qué.** El corte es por **mecanismo de ejecución**, no por área de producto. Cada uno de los cinco archivos tiene un modo de falla distinto y una política de seguridad distinta, y esos son los atributos que un lector necesita para razonar sobre el código:

- `host.zsh` es el único que escribe. Es reversible y de bajo riesgo.
- `privileged.zsh` no escribe nunca; es una tabla de reporte.
- `destructive.zsh` es el único irreversible.
- `refresh.zsh` es el único que mata procesos.
- `screenlock.zsh` es el único que no muta nada y cuyo output es un diagnóstico.

Un corte por área de producto (`ux.zsh`, `appstore.zsh`, `keyboard.zsh`…) cortaría por el eje equivocado: dentro de `keyboard.zsh` convivirían una escritura inocua, una operación privilegiada y un paso destructivo, y el gate de seguridad quedaría diluido en un archivo de 200 líneas que mezcla los tres modos.

**Por qué no 14 archivos.** Once de las catorce áreas propuestas (`appstore`, `keyboard`, `trackpad`, `screen`, `finder`, `dock`, `mission-control`, `browser`, `messages`, `mail`, `spotlight`) están enteramente en el scope de `darwin-system-config`. Un archivo por área fuerza que se cree un archivo vacío por cada área diferida, y peor: sugiere que esas áreas son responsabilidad de este módulo, lo que es exactamente la ambigüedad de fuentes de verdad que el scope cerrado busca evitar. `others` y `automatic-updates` sí tienen residuo, y ese residuo cae exactamente en `privileged.zsh`.

**Los archivos de área se sourcean incondicionalmente, ANTES de cualquier dispatch de OS** — el mismo precedente de `zsh/modules/apps/internal/main.zsh:4`, donde `webapp.zsh` se sourcea en la línea 4 y el `case "${OSTYPE}"` arranca en la línea 6.

**Por qué, y por qué el dispatch de `internal/` desaparece.** La razón honesta es que en este módulo el dispatch de OS en la capa `internal/` **no tendría ninguna rama que tomar**. `internal/osx.zsh` y `internal/linux.zsh` serían stubs de comentario de 2 líneas, exactamente como lo son en `zed` y en `apps` (verificado: ambos tienen 2 líneas, solo un comentario). El módulo ya tomó su decisión de plataforma mucho antes, en la capa `config/`: `config/linux.zsh` pone `ZSH_OSX_ENABLED=false`, y `plugin.zsh` hace `$ZSH_OSX_ENABLED || return` antes de sourcear `internal/`. Un segundo dispatch de OS sería redundante y código muerto.

Lo que sí se conserva de la guía es el archivo por defecto y su razón: `config/osx.zsh`, `config/linux.zsh`, `pkg/osx.zsh` y `pkg/linux.zsh` se crean siempre. `internal/osx.zsh` e `internal/linux.zsh` se omiten, autorizados por el *"(optional, only if needed)"* del checklist (líneas 749-750), porque no hay contenido que ponerles.

De segundo orden: como los archivos de área llevan **datos y política** —la tabla de operaciones, las gates, los predicados— y no ejecución de comandos macOS, son legibles y verificables sin un Mac. Eso es lo que permite validar la forma de la tabla y la política de gates en Linux, en CI, con shellcheck.

**Namespacing.** Las funciones se nombran `osx::internal::<area>::<action>`, siguiendo el precedente de `apps::internal::webapp::*` (`zsh/modules/apps/internal/webapp.zsh:3,52,92`) y la fila *Sub-functions* de la sección 8 de la guía (línea 677).

**Alternativas rechazadas:**

- **Los 14 archivos del ticket.** Rechazado: 11 de 14 estaría vacíos y atribuirían al módulo ownership de áreas que pertenecen a `darwin-system-config`.
- **Un solo `internal/base.zsh` monolítico.** Rechazado: es el error opuesto. Mezclaría escritura, no-escritura, irreversibilidad y `killall` en un archivo, y haría que el gate de seguridad fuera una de 30 funciones en vez de un límite legible. El corte por mecanismo existe para que un revisor pueda verificar el gate leyendo **un** archivo.
- **Mover `privileged.zsh` a `config/base.zsh`.** Atractivo —los datos son configuración— pero rechazado: `config/` es para variables de entorno con overrides de usuario (guía, sección 3), y una tabla de 12 operaciones con 4 campos por fila no es un override de entorno. Se mantiene en `internal/` para que `config/` siga siendo trivial de auditar.
- **Subdirectorios por área** (`internal/host/defaults.zsh`). Rechazado: con 5 archivos y ~15 funciones no hay densidad que justifique un nivel más de anidamiento.

---

### D2. Las 12 operaciones privilegiadas son una tabla, no 12 warnings

**Elegido.** Una zsh asociativa declarada en `config/base.zsh`, renderizada por un único loop en `internal/privileged.zsh`.

**Forma concreta.** Cinco campos por entrada, indexados por el número de línea del source (que es la identidad estable y verificable de cada operación):

```zsh
typeset -gA ZSH_OSX_PRIVILEGED_OPS
ZSH_OSX_PRIVILEGED_OPS=(
  [software-update-auto-install]='365:/Library/Preferences/com.apple.SoftwareUpdate.plist:AutomaticallyInstallMacOSUpdates:-bool:true'
  [commerce-auto-update]='368:/Library/Preferences/com.apple.commerce.plist:AutoUpdate:-bool:true'
  [mute-startup-chime]='482::SystemAudioVolume:-str: '
  [restart-freeze]='488::setrestartfreeze:-flag:on'
  [computer-name]='498::ComputerName:-str:${ZSH_OSX_COMPUTER_NAME}'
  [host-name]='499::HostName:-str:${ZSH_OSX_COMPUTER_NAME}'
  [localhost-name]='500::LocalHostName:-str:${ZSH_OSX_COMPUTER_NAME}'
  [netbios-name]='501:/Library/Preferences/SystemConfiguration/com.apple.smb.server:NetBIOSName:-str:${ZSH_OSX_COMPUTER_NAME}'
)
```

Cinco campos separados por `:`: **origen**, **target** (plist path o `defaults` domain, vacío para `nvram` / `systemsetup` / `scutil`), **key**, **type** (`-bool` / `-int` / `-str` / `-flag`), **value**. `source_line` es la clave del array; `target`, `key`, `type` y `value` son los cuatro datos.

**Detección y reporte de valor vacío.** Este es el punto que hace que la tabla sea necesaria y no solo elegante.

El source tiene un bug verificado por grep: la variable que respalda las 4 llamadas de hostname aparece **4 veces y se asigna 0 veces** en todo el repo. Las 4 quedarían escribiendo una cadena vacía. Un `scutil --set ComputerName ""` no es un no-op: **borra el nombre configurado** y deja la máquina en un estado de red degradado que es difícil de diagnosticar y tedioso de revertir.

El módulo no hereda ese bug. `ZSH_OSX_COMPUTER_NAME` se exporta en `config/base.zsh` con default `""`. El renderer evalúa el campo `value` **después** de la interpolación de shell, y en el primer valor vacío emite:

```
message_warning "Privileged op skipped: host-name (zsh-osx:499) — ZSH_OSX_COMPUTER_NAME is empty"
```

y cuenta la operación como **skipped**, no como done. El resultado de `osx::sync` reporta los tres estados por separado: `applied` (0, por definición), `documented` (8) y `skipped` (4). Esto convierte un bug silencioso del source en un output accionable que le dice al usuario exactamente qué variable setear.

**Por qué una tabla y no 12 strings.** Con 12 `message_warning` escritos a mano:

- La tabla de contenido real (qué plist, qué key, qué valor, qué comando exacto) se repite en dos lugares por cada operación —el warning y el README— y diverge con el tiempo. Con la tabla hay **una** fuente: el renderer emite el warning Y el README se genera desde la misma tabla.
- Contar, agrupar y testear es trivial: `for op in ${(ko)ZSH_OSX_PRIVILEGED_OPS}`. Con strings, no hay forma de preguntar "¿cuántas operaciones hay y cuáles se saltaron?".
- Agregar una operación es agregar una fila, no escribir un warning. El mecanismo de gate no se toca.
- El valor vacío se detecta en **un** lugar. Con 12 strings, la detección tiene que estar en los 12 — y es exactamente el tipo de chequeo que se omite en la entrada 11 de 12.

**Por qué en `config/base.zsh` y no en `internal/privileged.zsh`.** Porque es override de usuario por diseño: un usuario que quiere que el hostname se reporte con su valor real lo setea en `~/.customrc` exportando `ZSH_OSX_COMPUTER_NAME`. Un literal hardcodeado en `internal/` haría imposible esa customización sin editar código del módulo. La tabla es dato declarativo, y `config/` es donde viven los datos declarativos en esta arquitectura.

**Alternativas rechazadas:**

- **12 funciones `message_warning` hardcodeadas.** Rechazado: duplica el contenido en dos lugares, no es contable, y hace que el chequeo de valor vacío dependa de que el implementador se acuerde de ponerlo 12 veces.
- **Ejecutar los `sudo` y dejar que fallen.** Rechazado por decisión del usuario y porque el prompt de `sudo` en un shell no interactivo cuelga el proceso. Un no-op documentado es estrictamente mejor que un hang.
- **Detectar el `sudo` disponible y ejecutar si lo está.** Rechazado: convierte una decisión de política en un comportamiento dependiente del entorno. Un `osx::sync` que a veces escribe en `/Library/Preferences` y a veces no, según dónde corre, es impredecible.
- **Ejecutar vía `osascript` con `administrator privileges`** (el mecanismo moderno, sin `sudo` en el PATH). Rechazado por la misma razón, y además agrega la dependencia de un diálogo GUI que cuelga en SSH.
- **Tabla como archivo YAML en `data/`.** Atractivo para `darwin-system-config` consumirla. Rechazado para este propósito: las operaciones privilegiadas no las implementa nix-darwin (no las puede), así que no hay consumidor declarativo. El YAML sí se usa, pero para el inventario — ver D6.

---

### D3. Gate de las operaciones destructivas

**Elegido.** Réplica de la forma de `clean`, con gates propias del módulo.

**Los gates, y la semántica que los hace seguros:**

- **`ZSH_OSX_CONFIRM`** (default `true`) — Controla si se pregunta. El default `true` significa que "no hacer nada" es el default.
- **`ZSH_OSX_DESTRUCTIVE`** (default `false`) — **Kill switch.** Cuando es `false`, las operaciones destructivas no están disponibles en absoluto: la función reporta y retorna 1 sin preguntar. Este es el flag que las hace inalcanzables, y su default `false` es lo que garantiza que ninguna sesión, script ni CI las ejecute por accidente.
- **`ZSH_OSX_FORCE`** (default `false`) — Salta el prompt. Existe para uso no interactivo **explícito**; nunca se pone en `~/.customrc` por defecto.

**El helper.** `_osx::confirm <mensaje> [contexto]`, en `internal/destructive.zsh`. Misma firma que `_cleanup::confirm` (`zsh/modules/clean/internal/base.zsh:22-38`): imprime el mensaje, `read -r response`, y **solo acepta `[Yy]`** — cualquier otra cosa, incluido un Enter vacío, es un no. Esa asimetría es intencional y se conserva: el default del prompt es "no".

**La diferencia clave con `clean`, y por qué es necesaria:** `clean` envuelve sus operaciones destructivas con un gate de `confirm`; su efecto irreversible está siempre **alcanzable** desde un prompt. Acá el efecto irreversible (el wipe del Dock) no tiene vuelta. Por eso `clean`'s `ZSH_CLEAN_CONFIRM` se mapea a `ZSH_OSX_DESTRUCTIVE` (kill switch) y no a `ZSH_OSX_CONFIRM` (pregunta). `ZSH_OSX_CONFIRM` controla si se pregunta una vez que la capacidad está habilitada; `ZSH_OSX_DESTRUCTIVE` controla si la capacidad existe.

**Las dos operaciones:**

- **`_osx::internal::destructive::rebuild_launch_services`** — `lsregister -kill -r -domain local -domain system -domain user` (`zsh-osx/internal/base.zsh:38`). Gated. Reversible en efecto (Launch Services se reconstruye solo si se rompe algo, y el sistema lo refaz), pero disruptivo. Aplica a las tres operaciones destructivas la misma política: kill switch + confirmación.
- **`_osx::internal::destructive::wipe_dock`** — `com.apple.dock static-only -bool true` + `com.apple.dock persistent-apps -array` (`zsh-osx/internal/base.zsh:320-323`). Gated, y el prompt **declara explícitamente que no hay backup**. El wipe borra todos los iconos del Dock y el source no guarda nada; el usuario los recupera re-arrastrando, no con un comando.

**Sesiones no interactivas.** Se detectan con `[[ -t 0 ]]`. En una sesión sin TTY (pipe, `zsh -c`, CI, cron, un hook de herramienta que no abre terminal) el prompt no puede ejecutarse: `read` falla y devolvería 0 o colgaría, según el caso. El helper **no pregunta y retorna 1** con un `message_warning` que nombra el flag a setear explícitamente. La consecuencia: sobre SSH sin TTY interactivo, o en cualquier runner, una operación destructiva es imposible salvo que alguien haya puesto `ZSH_OSX_FORCE=true` a mano. Es el comportamiento que queremos — la capacidad de destruir el Dock nunca debería depender de que un `read` teve la suerte de devolver una `y`.

**Por qué `core::confirm` no se agrega.** Verificado por grep: no existe en el repo. Agregarlo al core sería cambiar `zsh/system/core/`, que está fuera del scope declarado de este cambio ("`zsh/modules/osx/` — módulo nuevo"), para tener exactamente un consumidor. Un helper de core con un consumidor es un compromiso de API pública a cambio de nada. Si aparece un segundo consumidor, la extracción es el movimiento correcto — y para entonces se verá qué forma necesita realmente.

**Por qué el guía no toca el shell de `ZSH_DISABLED_MODULES`.** La desactivación del módulo pasa por `~/.customrc` con `ZSH_DISABLED_MODULES="osx"`, ya soportado por `zsh/zshrc:57-62` para todos los módulos. No necesita un mecanismo propio.

**Alternativas rechazadas:**

- **Agregar `core::confirm` al core.** Rechazado: scope creep sobre `zsh/system/core/`, un consumidor no justifica una API pública nueva, y el nombre `core::confirm` implica una política genérica de confirmación que el módulo `clean` no adoptó (prefirió un helper local). Agregarlo al core también implica decidir qué pasa con `clean` — una refactorización de otro módulo que este cambio explícitamente no toca.
- **Sourcear las funciones destructivas solo bajo el flag, para que "simplemente no existan".** Rechazado: hace la capacidad **indescubrible** (el usuario no puede ni ver que existe) e **intestable** (no hay forma de verificar la forma del gate sin habilitar la capacidad). Con la función siempre definida, `osx::sync` la puede listar, el README la puede documentar y un test la puede invocar con el flag en `false` para verificar que retorna 1 sin preguntar. La seguridad viene del **default en `false`**, no de la ausencia de la función.
- **Un módulo wrapper genérico de `defaults`.** Rechazado: re-encapsula una herramienta del sistema, y el punto entero de este módulo es que el residuo es chico. Un wrapper de `defaults` sería un módulo con superficie grande y valor casi nulo, que además competiría con `darwin-system-config` por el mismo terreno.
- **Reusar `core::exists` / `core::ensure` para chequear `lsregister`.** Rechazado: `lsregister` no está en `PATH` por default (vive en `/System/Library/Frameworks/CoreServices.framework/.../lsregister`), así que `core::ensure lsregister` intentaría instalarlo vía `brew` y fallaría. Se resuelve con un check de path absoluto, que es un caso distinto del que `core::exists` cubre.
- **Prompt estilo y/N en vez de solo y.** Rechazado: `clean` acepta solo `[Yy]` y esa asimetría es correcta para operaciones irreversibles. Agregar un "sí a todo" sería relajar la protección en el nombre de la consistencia.

---

### D4. El refresco es explícito, nunca automático

**Elegido.** `osx::refresh` es un entry point público que el usuario invoca. No se llama al cargar el módulo, no es side effect de `osx::sync`, y no hay ningún hook de shell startup que lo dispare.

**Por qué es el valor central del módulo.** `killall Finder` (`zsh-osx/internal/base.zsh:306`) y `killall Dock` (`zsh-osx/internal/base.zsh:412`) son el mecanismo por el cual una sesión viva refleja defaults declarativos recién aplicados. nix-darwin **no puede** reiniciar procesos corriendo tras un rebuild — escribe el plist y nada más. La sesión del usuario sigue mostrando el Finder y el Dock con la config vieja hasta que algo los reinicia. Eso es exactamente el hueco que este módulo cubre, y es la razón por la que vale la pena existir.

**Por qué no automático después de apply.** Si `osx::sync` —o un hook post-apply— matara Finder y Dock, las consecuencias serían:

- **Cada shell nuevo.** Un hook de startup correría en cada shell interactivo. En un repo con N shells abiertos, un `killall` indiscriminado mata el Finder/Dock de **todas** las ventanas, no solo de la sesión que lo pidió. El efecto de un Finder que se reabre con la config nueva es aceptable; el efecto de cerrar 6 ventanas del Finder de otra persona en el mismo login, en otra máquina compartida, no lo es.
- **tmux y multiplexores.** Un hook de startup corre **una vez por pane nuevo** cuando el servidor tmux levanta un panel. Un usuario con un layout de 6 panes obtiene 6 shells nuevos por rebuild. Con refresh automático, el resultado es 6 intentos de `killall` que compiten entre sí. Con refresh explícito, el usuario lo corre una vez, cuando quiere.
- **Scripts.** Un `zsh -c "..."` no tiene idea de que está a punto de matar el Finder del usuario. En un script de provisioning, un `killall Dock` inyectado es un comportamiento impredecible.
- **SSH.** Un `zsh -c` remoto no tiene GUI que matar. El `killall` falla o, peor, en un host con un usuario remoto logueado, mata la sesión gráfica de otra persona.

En los cuatro casos el problema es el mismo: el usuario no pidió un reset de su escritorio, y el módulo lo hizo igual. La regla es: **nada que afecte la sesión de escritorio se ejecuta sin que alguien lo pida en ese momento.**

**Cómo se mitiga entonces la fricción.** `osx::refresh` imprime, después de cada `killall`, una línea que le dice al usuario que la sesión ya refleja la config nueva. El coste de ser explícito es un comando. El coste de ser automático es un escritorio inusable en tmux.

**Por qué `osx::refresh` no pide confirmación.** Un `killall Finder` no es destructivo en el sentido de D3: el proceso vuelve, la config del usuario no se toca, y el estado anterior (ventanas abiertas) se pierde, lo cual es un coste aceptable y **esperado** para un refresh explícitamente pedido. Pedir confirmación agregaría un paso a la única operación que el usuario **ya decidió** hacer. Además los dos `killall` están detrás de `ZSH_OSX_REFRESH` (default `true`) por simetría con el resto del módulo — pero un default `true` con acción explícita es un default seguro.

**Alternativas rechazadas:**

- **Refresh automático al final de `osx::sync`.** Rechazado por las cuatro razones de arriba. Es el error más caro de los cinco: un bug en esta decisión rompe el escritorio del usuario de forma repetida e inexplicable, y es el tipo de falla que no se reproduce en desarrollo porque el `while` de shells es local.
- **Refresh automático tras un rebuild de nix-darwin** (detectar el cambio de `system.defaults` comparando un hash del plist). Rechazado: agrega una dependencia de nix-darwin al módulo, que es lo contrario de la separación que justifica el scope. `darwin-system-config` no debe conocer a `osx` para que `osx` funcione.
- **Un `chpwd` o un trap que refresque.** Rechazado: `chpwd` dispara en cada `cd`. Un refresh en `cd` sería peor que uno en startup.
- **Dejar que el usuario haga `killall Finder` a mano y no ofrecer el helper.** Rechazado: entonces el módulo no cubre su propio valor central, y documentar un comando externo en un README es más pobre que encapsularlo detrás de un entry point que además anuncia el efecto.

---

### D5. Superficie de la API pública, y la contradicción del ticket

**La contradicción.** El ticket Jira lista el scaffold como `pkg/{base,main,osx,linux,helper,alias}.zsh` — sin `setup.zsh` — pero su criterio de aceptación exige que `type osx::setup` devuelva `"function"`. Los dos requisitos no pueden cumplirse a la vez si el orquestador vive en un archivo nuevo.

**Resolución elegida.** El orquestador va en **`pkg/helper.zsh`** como `osx::setup`. Esto satisface ambos: los 18 archivos del ticket existen tal cual listados, y `type osx::setup` responde `"function"`. No se agrega ningún archivo que la guía no liste.

**Por qué es la resolución correcta y no un compromiso.** La sección 5 de la guía (líneas 411-445) documenta literalmente `<name>::setup` **dentro de `pkg/helper.zsh`**, y el `pkg/helper.zsh` de `zed` —el módulo de referencia— lo tenía ahí antes de que se moviera. El criterio de aceptación del ticket y la guía coinciden. La contradicción estaba en la lista de archivos del ticket, que quedó desactualizada respecto a su propio criterio.

**Nota sobre `zed`, para que nadie lo copie.** `zed` tiene **ambos**: `pkg/helper.zsh` (que ahora es un comentario de una línea: `# Setup moved to pkg/setup.zsh`) y `pkg/setup.zsh` (que tiene `zed::setup`). Ese es un artefacto de una migración, no un patrón. `osx` sigue la guía: `osx::setup` en `pkg/helper.zsh`, y `pkg/helper.zsh` no es un stub.

**La API pública completa — 5 funciones:**

| Función | Qué hace | Archivo |
|---|---|---|
| `osx::install` | Verifica precondiciones en macOS. No instala nada. | `pkg/base.zsh` |
| `osx::sync` | Ejecuta el residuo: host-scoped, reporte de privilegiadas, drift de screen-lock. | `pkg/base.zsh` |
| `osx::refresh` | `killall Finder` + `killall Dock`. | `pkg/base.zsh` |
| `osx::post_install` | Wrapper de sync, por la convención de la guía. | `pkg/base.zsh` |
| `osx::setup` | Orquestador: `install` + `sync`. | `pkg/helper.zsh` |

`osx::refresh` vive en `pkg/base.zsh` y no en `pkg/osx.zsh` porque es la única función de la API que **solo tiene sentido en macOS pero cuyo nombre debe ser invocable igual** — igual que `osx::sync`, que también es macOS-only. Si `osx::refresh` estuviera en `pkg/osx.zsh`, en Linux no existiría y `type osx::refresh` fallaría, rompiendo la simetría de la API. La protección es `ZSH_OSX_ENABLED=false` en la capa `config`, no la ausencia de la función.

**`osx::install` no instala nada — y eso necesita justificación.** La guía asume que `install` descarga el binario del módulo (`curl | bash`). Este módulo no tiene binario: es una tabla de datos y un reporte. Su "instalación" son los precondiciones —`defaults` presente en `PATH` en macOS, `killall` presente, escritura al directorio `data/`— y fallar con un mensaje claro si no están. Una función de install vacía es mejor que una función de install que finge: el usuario que corre `osx::setup` en una máquina mal formada obtiene un diagnóstico, no un `curl` a la nada.

**`osx::sync` no emite nada.** Consistente con el source (que usa solo `message_info` / `message_success`), `osx::sync` no emite un header ni un footer. Toda la salida viene de las callees. Esto hace que el output de `osx::sync` sea componible: un usuario que lo pipea a un archivo obtiene exactamente las acciones y advertencias, sin ruido de andamiaje.

**`osx::packages` — descartada.** Es un stub muerto en `zsh-osx/internal/base.zsh:557` con **cero callers** en todo el source. Y `zsh/modules/apps/` ya implementa instalación de casks por plataforma con `core::ensure`, correctamente. Reimplementarlo violaría la regla de Core Reuse de la guía ("Never reimplement these") y crearía una segunda ruta de instalación de paquetes en macOS. El módulo **documenta la delegación** a `apps::packages::install` en su README en vez de duplicarla.

**`git config --global alias.lastchange` — descartada.** `zsh-osx/internal/base.zsh:473` escribe un alias en el `~/.gitconfig` del usuario. Un módulo de settings de macOS no debe escribir la configuración de Git de nadie: es una violación de dominio que no tiene relación con el nombre del módulo, no es reversible por el mecanismo del módulo, y un usuario que desinstala `osx` no espera que su `.gitconfig` cambie. Si alguien quiere ese alias, va en `zsh/modules/git/`, que ya existe.

**Por qué el refresh no está en `osx::setup`.** `osx::setup` corre automáticamente desde el flujo de instalación de un módulo nuevo. Si `setup` hiciera refresh, instalar el módulo en una shell mataría el Finder del usuario como efecto de instalar. La separación install/sync vs refresh es directa: `setup` **configura**, `refresh` **resetea la sesión**, y son cosas que el usuario quiere en momentos distintos.

**Alternativas rechazadas:**

- **Crear `pkg/setup.zsh` y violar la lista de 18 archivos.** Rechazado: resuelve la contradicción sacrificando el otro requisito, y agrega un archivo que la sección 5 de la guía no contempla. La guía es la fuente de verdad de la estructura; el ticket está desactualizado.
- **Poner `osx::setup` en `pkg/base.zsh`.** Rechazado: la guía separa explícitamente wrappers finos (`base.zsh`) de orquestadores que componen múltiples funciones públicas (`helper.zsh`). `osx::setup` compone.
- **`osx::refresh` como efecto de `osx::sync`.** Rechazado — es D4.
- **Migrar `osx::packages` "por completitud".** Rechazado: stub sin callers + duplicación de `apps`. Completitud a costa de Core Reuse no es completitud.
- **Migrar el alias de git "porque estaba en el original".** Rechazado: el módulo no es de Git. La revisión de qué del source se migra es el trabajo real de este cambio, no un `cp` del inventario.
- **Agregar `osx::screenlock` a la API pública.** Rechazado: el screen-lock es un **reporte**, no una acción. Se emite como parte de `osx::sync`; darle un entry point separado sugeriría que el usuario puede pedir el reporte por sí solo, lo cual no es un caso de uso real.
- **`osx::destructive` como API pública.** Rechazado: expone las operaciones irreversibles a un typo. Se llegan a través de las gates documentadas; nadie escribe `osx::destructive` a mano.

---

### D6. Naming, variables, y el bug que hay que evitar

**Guard y path.** `__ZSH_OSX_LOADED` como guard de idempotencia; `ZSH_OSX_PATH="${0:A:h}"`. El spelling `${0:A:h}` es el de `zsh/modules/apps/plugin.zsh:8` y el que la guía especifica (línea 171). `zed` usa el más débil `$(dirname "${0}")`, que no resuelve symlinks — un symlink al módulo haría que `${0}` fuera el link, no el directorio real, y todos los `source` relativos fallarían. Se usa el fuerte.

**`message_info` con literal, NO con variable — el bug a evitar.** `zsh/modules/zed/plugin.zsh:10` corre `message_info "Loading module: ${ZED_PACKAGE_NAME}"`, pero `ZED_PACKAGE_NAME` solo se exporta **después**, en `zsh/modules/zed/config/base.zsh:4`, y el source de `config/main.zsh` ocurre en `zed/plugin.zsh:13`. En el primer load el valor está vacío y el mensaje renderiza `[INFO]: Loading module: `.

**El módulo `osx` usa el literal:** `message_info "Loading module: osx"`. No una variable.

> **Para el implementador: no copies el patrón de `zed`.** Es un bug, no un estilo. Un mensaje de carga que renderiza vacío es peor que no tener mensaje: oculta que el módulo se cargó. Si más adelante se quiere la variable, tiene que estar declarada **antes** de la línea del mensaje.

**Prefijo de variables.** `config/base.zsh` usa `ZSH_OSX_` en **todas** las variables, conforme a la sección 8 de la guía (líneas 664-680) y su regla explícita de que el prefijo `ZSH_` namespacea contra colisiones con herramientas externas. No se sigue el patrón legacy sin prefijo que todavía usan `starship`, `nvim` y `apps` (`ZED_PACKAGE_NAME`, `APPS_JETBRAINS`). Esos son deuda histórica; `herdr` es el módulo que se estandarizó al patrón correcto y es el que la guía cita.

**`config/linux.zsh` desactiva el módulo.** Asignación simple más el disable de shellcheck:

```zsh
# shellcheck shell=bash
# shellcheck disable=SC2034
# Linux-specific osx config — this module is macOS-only
ZSH_OSX_ENABLED=false
```

Ese es el mecanismo exacto de `zsh/modules/hyprland/config/osx.zsh:4` y `zsh/modules/waybar/config/osx.zsh`. El `# shellcheck disable=SC2034` es necesario porque `ZSH_OSX_ENABLED` se asigna en un archivo y se lee en `plugin.zsh`, y shellcheck no ve el uso cross-file.

**Nota sobre `hammerspoon`.** `zsh/modules/hammerspoon/config/linux.zsh` es el caso espejo —un `linux.zsh` que desactiva— pero usa `export` en vez de asignación simple. Los dos son funcionalmente equivalentes para este propósito, y `hyprland`/`waybar` son el precedente mayoritario y más simple. Se sigue la asignación simple.

**Los dos archivos de plataforma siempre existen en disco, para todos los módulos.** El archivo nunca se omite; el disable ocurre **dentro** de él. La sección 6 de la guía (líneas 497-501) explica por qué: "documentan que el módulo soporta ambas plataformas y los futuros desarrolladores saben dónde agregar código específico". Un `linux.zsh` ausente hace que el `case` de `config/main.zsh` sea un `case` con un brazo muerto y sin registro visible de la decisión.

**El artefacto de inventario.** `zsh/modules/osx/data/migration-inventory.yaml`, referenciado por `ZSH_OSX_MIGRATION_INVENTORY="${ZSH_OSX_DATA_PATH}/migration-inventory.yaml"` exportado en `config/base.zsh`.

YAML por dos razones concretas: (1) `darwin-system-config` es un módulo Nix y su consumidor natural es un parser de datos estructurados, no un humano; (2) el repo ya tiene convención YAML para artefactos de datos (`README.yaml`, `data/settings.json`, templates gomplate). El archivo lleva un bloque de metadatos de versión al tope (`schema_version`, `source`, `source_commit`, `generated_for`, `scope_exclusions`) para que el consumidor pueda fallar explícitamente si el schema cambió en vez de parsear garbage.

El YAML **no** es la fuente de la tabla de operaciones privilegiadas (D2), porque esas operaciones no las implementa nix-darwin y por lo tanto no hay consumidor declarativo para ellas. Dos formatos, dos audiencias: tabla en shell para lo que el módulo hace, YAML para lo que otro change va a hacer.

**Alternativas rechazadas:**

- **Copiar el patrón de `zed` con `${ZSH_OSX_PACKAGE_NAME}`.** Rechazado: es el bug documentado arriba. Además, `ZSH_OSX_PACKAGE_NAME` no es una variable que este módulo necesite —no hay paquete que instalar— así que declararla solo para el mensaje de carga sería una variable muerta.
- **`ZSH_OSX_PATH="$(dirname "${0}")"`.** Rechazado: no resuelve symlinks. Verificado que `zed` lo usa y `apps` no; la guía especifica el fuerte.
- **Nombres sin prefijo `ZSH_`** al estilo legacy de `apps`/`nvim`/`starship`. Rechazado: la sección 8 de la guía dice explícitamente que el prefijo existe para evitar colisiones, y `herdr` es el estándar citado. Mismo nombre, prefijo distinto = el peor de los dos mundos: el prefijo no evita la colisión con las variables legacy de otros módulos.
- **Colocar el inventario en `docs/` o en el directorio del change de OpenSpec.** Rechazado: tiene que vivir con el código que lo produce. Si se mueve a OpenSpec, se vuelve un artefacto histórico que se desactualiza silenciosamente cuando el módulo cambia. En `data/` se versiona junto al código y el `README.md` puede enlazarlo.
- **Un subdirectorio `data/inventory/`.** Rechazado: hay un solo artefacto. Un nivel de anidamiento para un archivo es prematuridad estructural; si aparece un segundo artefacto, se agrega el subdirectorio en ese momento.
- **Markdown en vez de YAML.** Rechazado: el consumidor es `darwin-system-config`, no una persona. Markdown para un consumidor de máquina es parsing frágil.

---

### D7. Helpers de core a reusar, y sus trampas

**Se reusan, nunca se reimplementan:**

| Helper | Wrapper público | Implementación | Uso en `osx` |
|---|---|---|---|
| `message_info` | `zsh/system/core/pkg/base.zsh:34-36` | `internal/api.zsh:41-43` | Header de sync, anuncios de refresh |
| `message_success` | `pkg/base.zsh:46-48` | `internal/api.zsh:54-56` | Cierre de operaciones aplicadas |
| `message_warning` | `pkg/base.zsh:42-44` | `internal/api.zsh:50-52` | Operaciones privilegiadas documentadas, gates, drift |
| `message_error` | `pkg/base.zsh:38-40` | `internal/api.zsh:45-48` | Paths no escribibles, precondiciones fallidas |
| `core::exists` | `pkg/base.zsh:14-16` | `internal/api.zsh:29-39` | Chequeo de binarios del sistema |
| `core::ensure` | `pkg/base.zsh:18-20` | — | Precondiciones de `osx::install` |

**Trampa 1 — `message_error` retorna 0.** `internal/api.zsh:45-48` hace `printf ...; return 0`. **Retorna 0 explícitamente.** No falla la función que la llama.

Esto es contraintuitivo y es la trampa más peligrosa de las dos, porque su consecuencia es silenciosa: un path de error que solo hace `message_error "..."` y nada más retorna **éxito**. En un `osx::sync` que termina con `[[ -n "${errors}" ]] && return 1`, ese chequeo pasa, el caller cree que todo salió bien, y un fallo real se pierde.

**Regla para el implementador: todo path de error termina con `return 1` explícito.** El `message_error` es la salida; el `return 1` es la señal. Se usan juntos, nunca uno sin el otro. Ejemplo del shape correcto:

```zsh
if ! defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true; then
  message_error "TCC denied the write to com.apple.controlcenter — see R-TCC in the README"
  return 1
fi
```

**Trampa 2 — `core::exists` cachea resultados.** `internal/api.zsh:27-39` mantiene `_CORE_EXISTS_CACHE`, una asociativa global. Solo cachea resultados **positivos** (comentario explícito en las líneas 31-32: "Missing tools always re-probe so check->install->re-check flows stay correct after installs"). Un binario ausente se re-sondea cada vez, lo cual está bien.

Lo que **no** está bien: un binario que **aparece** a mitad de sesión se lee como ausente si ya se cacheó un negativo... no, al revés: un negativo nunca se cachea, así que un binario que aparece se detecta correctamente en la llamada siguiente. El caso problemático real es el inverso: un binario presente se cachea como presente, y si se **desinstala** a mitad de sesión, `core::exists` sigue reportándolo presente. En el contexto de `osx` esto importa para `lsregister` (que no está en `PATH`) y para cualquier chequeo de precondición: si el usuario desinstala algo y re-corre `osx::setup` en la misma shell, el chequeo puede pasar con un binario que ya no está.

**Consecuencia de diseño, no un bug a arreglar:** por eso `osx::install` **no** cachea sus precondiciones en una variable del módulo, y por eso la verificación del path absoluto de `lsregister` (D3) se hace con un test de archivo directo en vez de con `core::exists`. `core::exists` es correcto para "is esta herramienta en PATH"; no es el tool correcto para "existe este path absoluto del sistema". No se extiende `core::exists` para cubrir ese caso — el módulo chequea el path.

**Shellcheck.** El hook de pre-commit (`.pre-commit-config.yaml:141-149`) corre shellcheck con `--exclude=SC1072,SC1073,SC2068,SC1091`. La regex de `exclude` cubre solo `.provision/git/hooks/prepare-commit-msg`, `.tpl.sh`, `.envrc` y `bin/*` — **no hay ninguna exclusión que apunte a `zsh/modules/**`**. Por lo tanto **cada archivo nuevo del módulo es checkeado**, sin excepción.

Consecuencia operativa: `# shellcheck source=/dev/null` va en la línea **inmediatamente anterior** a cada `source`. Es lo que hacen `zsh/modules/zed/pkg/main.zsh` y `zsh/modules/apps/plugin.zsh`. Y `message_error "..."` seguido de `return 1` también satisface a shellcheck (SC2317 no aplica a este caso; lo que hay que evitar es el `return` no alcanzado, que no ocurre con este shape).

**Alternativas rechazadas:**

- **Un wrapper local `_osx::info` / `_osx::error`.** Rechazado: la guía lo prohíbe explícitamente en el checklist "Never" (líneas 769-773: "No `message_*` reimplementations").
- **Un helper local `_osx::fail <msg>` que envuelva `message_error` + `return 1`.** Atractivo — mata la trampa 1 de un tiro. Rechazado: es un `message_error` reimplementado con un `return` agregado, y reintroduce exactamente la clase de abstracción que la guía prohíbe. El costo de la trampa se paga con **convención documentada** (este doc, D7), no con indirección.
- **Arreglar `message_error` para que retorne 1.** Rechazado por scope: cambiar `zsh/system/core/internal/api.zsh` afecta a **todos** los módulos que hoy dependen de su `return 0`. Un cambio de semántica en un helper compartido es exactamente el tipo de cosa que este cambio aditivo no debe hacer. La trampa se documenta; el fix es un change separado, si algún día se decide que vale la pena.
- **Extender `core::exists` para aceptar paths absolutos.** Rechazado: `core::exists` cachea, y un path absoluto no debe cachear (cambia cuando el archivo aparece). Agregar un modo no-cacheado al helper compartido es una decisión de diseño de `core` que excede este cambio. El chequeo del path se hace en el módulo.
- **`--exclude` en el hook pre-commit para `zsh/modules/osx`.** Rechazado: agrega deuda al hook. Los módulos existentes pasan shellcheck sin exclusiones; no hay razón para que este sea la excepción.

---

### D8. Puntos de registro

**Exactamente dos ediciones en el `Taskfile.yml` raíz, ambas alfabéticas.** Este es el punto donde se cometen los errores silenciosos: si falta cualquiera de las dos, el módulo funciona pero **el README nunca se genera** y nadie se entera hasta que un revisor lo nota.

**Edición 1 — el include, entre `module-notify` y `module-nvim`:**

```yaml
  module-notify:
    taskfile: ./zsh/modules/notify/Taskfile.yml
  module-osx:                                    # ← insertar
    taskfile: ./zsh/modules/osx/Taskfile.yml
  module-nvim:
    taskfile: ./zsh/modules/nvim/Taskfile.yml
```

**Edición 2 — la dependencia en `readme:modules`, en la misma posición relativa** (hoy en las líneas 310-311):

```yaml
      - task: module-notify:readme
      - task: module-osx:readme                   # ← insertar
      - task: module-nvim:readme
```

**Ambas son obligatorias y ninguna es opcional.** El include sin la dependencia hace que `task module-osx:readme` funcione individual pero que `task readme:modules` no lo invoque — el README queda sin generar y nadie falla. La dependencia sin el include hace que `task readme:modules` falle con un error de task no encontrado. La forma que no falla es hacer las dos.

**El `Taskfile.yml` del módulo.** Espejo de `zsh/modules/zed/Taskfile.yml:5-13` con los paths cambiados:

```yaml
---
version: "3"

tasks:
  readme:
    desc: Generate module README.md
    silent: true
    cmds:
      - >-
        gomplate --file {{.README_MODULE_TEMPLATE}}
        --out zsh/modules/osx/README.md
        --datasource config=zsh/modules/osx/README.yaml
        --datasource includes={{.README_INCLUDES}}
```

**`README.yaml`** con el schema de 7 claves **en este orden exacto** (el orden importa — la plantilla gomplate las consume posicionalmente en este repo): `name`, `tags`, `license`, `github_repo`, `description`, `features`, `requirements`. `license: "LGPL-3.0"` y `github_repo: luismayta/dotfiles` son los valores de todos los módulos, incluido `zed`.

**No hay registro que mantener en `zshrc`.** `zsh/zshrc:57` itera `"${DOTFILES_ZSH_PATH}"/modules/*(/N` y sourcea cualquier `plugin.zsh` que encuentre. Crear el directorio es suficiente. La desactivación, si el usuario la quiere, es `ZSH_DISABLED_MODULES="osx"` en `~/.customrc`, soportada por el mecanismo genérico de `zshrc:59-62`.

**Alternativas rechazadas:**

- **Solo el include, sin la dependencia de `readme:modules`.** Rechazado: falla silenciosamente. Es el error de mayor costo de esta decisión porque no produce ningún error visible.
- **Solo la dependencia, sin el include.** Rechazado: falla ruidosamente (`task not found`), que es al menos detectable.
- **Generar el README a mano y commitearlo sin Taskfile.** Rechazado: el README es generado; un artefacto generado a mano se desactualiza en el próximo cambio de `README.yaml` sin que nada lo advierta. Se commitea, pero se genera con `task module-osx:readme`.
- **Un `alias osx=osx::setup` en `pkg/alias.zsh`.** A considerar… y rechazado: `osx` es un nombre que colisiona con la expectativa de un binario del sistema, y un alias que corre un sync con reporte de operaciones privilegiadas es más peligroso de lo que parece para lo que compra. `pkg/alias.zsh` existe vacío (ver D9) para que `pkg/main.zsh` pueda sourcearlo incondicionalmente, que es la razón por la que la guía lo exige.

---

### D9. Inventario de archivos — la cuenta de "18" es incorrecta

**El claim del ticket no se sostiene.** La aritmética verificada:

| Módulo | Archivos | Descomposición |
|---|---|---|
| `zed` | **22** | 17 `.zsh` + `Taskfile.yml` + `README.yaml` + `README.md` (generado) + 2 archivos de datos |
| `apps` | **20** | 16 `.zsh` + `Taskfile.yml` + `README.yaml` + `README.md` (generado) + `data/.gitkeep` |
| guía | 18 | checklist, con 6 ítems marcados *"(optional, only if needed)"* |

**Los 18 son un mínimo requerido, no un cap.** El checklist (líneas 738-757) marca explícitamente `config/osx.zsh`, `config/linux.zsh`, `internal/osx.zsh`, `internal/linux.zsh`, `pkg/osx.zsh` y `pkg/linux.zsh` como opcionales. `zed` y `apps` exceden 18 porque agregaron archivos de área (`apps/internal/webapp.zsh`, `zed/pkg/setup.zsh`) y archivos de datos. Diseñar contra el 18 literal significaría omitir las 5 áreas de D1 o el inventario de D6.

**El árbol exacto:**

```
zsh/modules/osx/
├── plugin.zsh                      # guard, path, mensaje literal, cadena de 3 capas
├── config/
│   ├── base.zsh                    # ZSH_OSX_ENABLED, tabla de ops privilegiadas, paths
│   ├── main.zsh                    # base + dispatch de OS
│   ├── osx.zsh                     # stub — contrato de plataforma explícito
│   └── linux.zsh                   # ZSH_OSX_ENABLED=false + disable de shellcheck
├── internal/
│   ├── main.zsh                    # sourcea los 5 de área en orden. SIN dispatch de OS.
│   ├── host.zsh                    # defaults -currentHost write
│   ├── privileged.zsh              # renderer de la tabla
│   ├── destructive.zsh             # _osx::confirm + las 2 operaciones
│   ├── refresh.zsh                 # killall Finder / Dock
│   └── screenlock.zsh              # detección de drift + ruta soportada
├── pkg/
│   ├── main.zsh                    # base + dispatch + helper + alias
│   ├── base.zsh                    # install, sync, refresh, post_install
│   ├── helper.zsh                  # osx::setup
│   ├── osx.zsh                     # stub — contrato de plataforma explícito
│   ├── linux.zsh                   # stub — contrato de plataforma explícito
│   └── alias.zsh                   # VACÍO, pero existe (ver abajo)
├── data/
│   └── migration-inventory.yaml    # entregable para darwin-system-config
├── Taskfile.yml
├── README.yaml
└── README.md                       # GENERADO por task module-osx:readme
```

**21 entradas, 20 versionadas** (`README.md` es generado). Contra los 18 de la guía: −3 por omitir `internal/base.zsh` + `internal/osx.zsh` + `internal/linux.zsh` (D1), +5 por los archivos de área, +1 por el archivo de inventario.

**`internal/base.zsh` no existe.** Es una consecuencia directa de D1: los 5 archivos de área cubren la capa `internal` completa. Un `base.zsh` con lógica compartida entre las áreas reintroduce el acoplamiento que el corte por mecanismo existe para evitar. Si las áreas necesitaran algo común de verdad, ese algo común sería un sexto archivo de área.

**`pkg/alias.zsh` existe aunque esté vacío.** La sección 5 de la guía lo dice dos veces (líneas 447-463, la segunda con el título duplicado): *"Always exists, even if empty — guarantees `pkg/main.zsh` can source it unconditionally"*. `pkg/main.zsh` sourcea `helper.zsh` y `alias.zsh` sin condición. Un `alias.zsh` ausente rompe el source en cada load de shell. El archivo lleva solo el header de shellcheck y un comentario. Precedente exacto: `zsh/modules/zed/pkg/alias.zsh` son 2 líneas.

**Los stubs de plataforma también existen aunque estén vacíos.** `config/osx.zsh`, `pkg/osx.zsh` y `pkg/linux.zsh` son 2 líneas: `# shellcheck shell=bash` más un comentario. Precedente exacto: `zsh/modules/zed/config/osx.zsh` y `zsh/modules/zed/pkg/osx.zsh` son 2 líneas cada uno. La razón de la guía (sección 6, líneas 497-501): documentan que el módulo soporta ambas plataformas y que agregar implementación después es un cambio de un archivo, no un refactor estructural.

**Alternativas rechazadas:**

- **Forzar exactamente 18 archivos.** Rechazado: obliga a meter las 5 áreas en 2 archivos (perdiendo el corte por mecanismo, que es D1) o a omitir el inventario (que es el entregable real del change).
- **Un `internal/base.zsh` por compatibilidad con la forma de `zed`.** Rechazado: `zed` tiene `internal/base.zsh` porque tiene un solo plano de trabajo (install + sync). `osx` tiene cinco mecanismos distintos. Copiar la forma sin la sustancia.
- **`data/.gitkeep` además del YAML.** Rechazado: `.gitkeep` existe en `apps` porque `data/` no tiene contenido. Acá el YAML vive en `data/`, así que el directorio ya está versionado por su contenido.
- **Versionar `README.md` sin generarlo.** Rechazado: ver D8.

## Risks / Trade-offs

**[R-TCC] → macOS TCC bloquea escrituras CLI a ciertos dominios de preferencias desde macOS 14/26.** Un `defaults write` a un dominio protegido por TCC puede ser denegado, y en algunos casos **fallar en silencio** —escribe 0, retorna 0— o ser bloqueado sin que `defaults` reporte nada útil. Un `osx::sync` que reporta éxito mientras el setting no cambió es el peor modo de falla posible: el usuario cree que tiene la config y no la tiene. **Mitigación, en tres capas:** (1) cada escritura host-scoped se **verifica con un read-back** — `defaults -currentHost read <domain> <key>` comparado contra el valor pretendido — y si no coincide, reporta por el path de error con `return 1` explícito (D7), nunca como éxito. (2) El renderer distingue `written` de `verified`, y el resumen de `osx::sync` reporta los dos conteos por separado, para que un 0 en `verified` sea visible de un vistazo. (3) La documentación del README nombra explícitamente el caso de Full Disk Access, porque la negación más común no es de TCC sino de FDA: la terminal (o iTerm2) necesita FDA para que un proceso CLI escriba en ciertos dominios. La caída de `verify` es un path de error explícito, no un silencioso.

**[R-DOCK] → El wipe del Dock es irreversible desde el módulo: no hay backup.** `com.apple.dock persistent-apps -array` borra todos los iconos del Dock, y el source no guarda nada antes de borrarlos. **Mitigación:** la operación está tras el kill switch `ZSH_OSX_DESTRUCTIVE` (default `false`), y el prompt de confirmación declara explícitamente que no existe backup y que la recuperación es manual (re-arrastrar iconos). El README documenta el procedimiento de export previo —`defaults export com.apple.dock -` a un plist— como la alternativa recomendada si el usuario quiere la operación. **Lo que no se hace, y es una decisión:** el módulo no toma el backup automáticamente. Un backup automático al lado de una operación que borra veinte iconos sin más añade un estado y un path de falla; el gate más un prompt honesto es la protección que corresponde a una operación que el usuario tiene que pedir explícitamente.

**[R-LSREG] → `lsregister -kill -r` reconstruye Launch Services en tres dominios y puede romper la resolución de apps y la indexación de Spotlight de forma transitoria.** El rebuild de `local`, `system` y `user` es una operación de varios segundos durante la cual macOS puede no resolver apps por nombre, los iconos en el Finder pueden aparecer como "generic", y Spotlight puede reindexar. **Mitigación:** misma política que las otras dos operaciones destructivas — kill switch `ZSH_OSX_DESTRUCTIVE` más confirmación explícita. Además, el módulo **nunca la llama en un flujo automático** (D4 la aplica integralmente: nada de esto corre sin que alguien lo pida). Y la documentación advierte que el efecto de la operación es transitorio y que Spotlight vuelve a indexar solo. `killall Finder` **no** es un mitigador de esto — son cosas distintas: el refresh reinicia el proceso del Finder, `lsregister` reconstruye la base de Launch Services. No se mezclan en el mismo helper.

**[R-NIX] → El módulo está acoplado a que `nix-darwin-support` aterrice. Si ese change se abandona, el módulo entrega solo el residuo pequeño y las ~150 claves declarativas quedan sin migrar.** Este es el trade central del cambio, y es aceptado. La alternativa —migrar las ~150 claves a un módulo imperativo— produce dos fuentes de verdad compitiendo por los defaults de macOS, que es un costo permanente y no recuperable; la de este diseño, un acoplamiento a un change hermano, es un costo contingente y recuperable. **Mitigación — el inventario versionado es la hedge:** `data/migration-inventory.yaml` contiene las ~150 claves con su valor pretendido, su origen en el source, su orden de sync, los pares duplicados y los conflictos de valor. Si nix-darwin nunca aterrice, ese archivo sigue siendo un análisis correcto y reutilizable — es la razón por la que el change vale la pena pese a la superficie de código pequeña. Y si el change se abandona, el inventario es el input listo para replantear la migración con el análisis ya hecho.

**[R-EMPTY] → Escrituras con valor vacío: cualquier operación privilegiada cuyo valor esté vacío debe reportarse como skipped, nunca escribirse.** Este es el bug verificado del source (`COMPUTER_NAME`: 4 usos, 0 asignaciones) convertido en un riesgo de diseño. Un `scutil --set ComputerName ""` no es un no-op: borra el nombre de red configurado y deja la máquina en un estado degradado difícil de diagnosticar. **Mitigación:** el renderer evalúa el campo `value` **después** de la interpolación de shell, y cualquier valor vacío emite `message_warning` nombrando la variable a setear y se cuenta como `skipped` en el resumen de `osx::sync` — con su propio conteo, separado de `documented`. La distinción entre "se documentó el paso manual" y "se saltó por falta de valor" es explícita en el output porque son dos problemas distintos con dos fixes distintos.

**[R-SHELLCHECK] → El hook de pre-commit corre shellcheck sobre `zsh/modules/osx/**` sin exclusión, y la guía no garantiza que el código de zsh pase shellcheck limpio.** Cualquier `# shellcheck disable=` mal colocado, un `source` sin la directiva `source=/dev/null` inmediatamente anterior, o una variable sin uso dispara un fallo de commit. **Mitigación:** el patrón de `# shellcheck source=/dev/null` está especificado en D7 y es exactamente el de `zed/pkg/main.zsh` y `apps/plugin.zsh`. El `disable` de `SC2034` en `config/linux.zsh` está especificado en D6. El riesgo residual es un SC nuevo no anticipado; se resuelve en el commit, no en el diseño.

**[R-NO-ROLLBACK] → Los efectos de `defaults` PERSISTEN en el plist del usuario; desactivar o borrar el módulo NO revierte los settings ya aplicados.** Este es el riesgo más fácil de subestimar y el que más sorprende al usuario. Es la contraparte de la sección de Migration Plan y se referencia cruzada allá. **Mitigación:** documentada en el README del módulo (sección de rollback) y en el plan de migración de este doc. La mitigación de código es limitada por naturaleza: `defaults` no tiene undo, y no se construye un.

**[R-DRIFT] → El drift de screen-lock depende de la ruta soportada, no de la clave que se reporta.** La clave `com.apple.screensaver askForPassword` está en el source pero dejó de ser el camino oficial (CIS Ventura Apple macOS 13 apunta a `sysadminctl -screenLock` o un perfil MDM). Un módulo que solo reportara el drift sin decir qué hacer sería un diagnóstico sin remedio. **Mitigación:** el reporte nombra **la ruta soportada** además del drift, y `data/migration-inventory.yaml` registra el hecho (mecanismo cambiado) para que el consumidor declarativo sepa que esa clave no es configurable vía `system.defaults`. El módulo **no escribe la clave** —escribirla en silencio sería perpetuar un default muerto.

## Migration Plan

**El cambio es aditivo. Ningún comportamiento existente cambia.**

### Habilitación

1. Crear el árbol de `zsh/modules/osx/` completo (D9). `zsh/zshrc:57` lo descubre automáticamente — **no hay paso de registro en `zshrc`**.
2. Las dos ediciones en el `Taskfile.yml` raíz, ambas alfabéticas (D8). Sin el include, `task module-osx:readme` no resuelve; sin la dependencia en `readme:modules`, el README nunca se genera.
3. `task module-osx:readme` para generar `README.md` desde `README.yaml`.
4. En Linux nada cambia: `config/linux.zsh` pone `ZSH_OSX_ENABLED=false` y `plugin.zsh` retorna antes de sourcear `internal/` y `pkg/`. En macOS el módulo aparece en el output de carga con `[INFO]: Loading module: osx`.
5. Si el usuario quiere el módulo apagado: `ZSH_DISABLED_MODULES="osx"` en `~/.customrc` (mecanismo genérico de `zshrc:59-62`), o `ZSH_OSX_ENABLED=false`.

### Verificación

```zsh
# 1. Carga limpia, una sola vez
source zsh/system/core/main.zsh && source zsh/modules/osx/plugin.zsh
#    esperado: [INFO]: Loading module: osx     ← CON el nombre, no vacío (D6)

# 2. Guard de idempotencia
source zsh/modules/osx/plugin.zsh
#    esperado: sin segunda línea de carga

# 3. API pública
for fn in osx::install osx::sync osx::refresh osx::post_install osx::setup; do
  type $fn   # → "function" en las cinco
done

# 4. Destructivas inalcanzables por default
ZSH_OSX_DESTRUCTIVE=false osx::sync
#    esperado: reporta skipped, retorna 1 en la operación destructiva, NO pregunta

# 5. Ops privilegiadas: 8 documentadas + 4 skipped por valor vacío
osx::sync 2>&1 | grep -c "documented\|skipped"
#    esperado: 8 documentadas, 4 skipped nombrando ZSH_OSX_COMPUTER_NAME

# 6. No destructivo en Linux
zsh -c 'source zsh/system/core/main.zsh && source zsh/modules/osx/plugin.zsh; type osx::sync'
#    esperado: el módulo no se carga (ZSH_OSX_ENABLED=false); sin error

# 7. Shellcheck
shellcheck --exclude=SC1072,SC1073,SC2068,SC1091 zsh/modules/osx/**/*.zsh
```

### Rollback — y la subtileza que hay que decir

**Lo que es limpiamente revertible:**

- Las 2 líneas del `Taskfile.yml` raíz. `git revert` de esas 2 líneas.
- El directorio `zsh/modules/osx/`. `git rm -r`. Como `zshrc:57` itera directorios existentes, borrar el directorio lo desaparece del discovery en la siguiente shell.

**Lo que NO es revertible: los efectos en el plist.** `defaults write` **persiste** en `~/Library/Preferences/<domain>.plist` del usuario. Desactivar el módulo (`ZSH_OSX_ENABLED=false`, `ZSH_DISABLED_MODULES`) o borrar el directorio completo **no revierte** ningún setting ya aplicado. No hay `defaults undo`; el módulo no construye uno.

**Opciones de restauración, en orden de preferencia:**

1. **Backup previo** (recomendado, y la única que restaura el estado exacto): `defaults export -` sobre los dominios tocados antes del primer `osx::sync`. Un `osx::refresh` no necesita backup (no toca preferencias), pero `osx::sync` sí.
2. **Restauración manual**: para cada key reportada por `osx::sync`, `defaults write <domain> <key> <valor-anterior>` leyendo el valor actual con `defaults read <domain> <key>` **antes** de aplicar. Esto es manual y propenso a errores; es la razón por la que la opción 1 es la recomendada.
3. **Rollback vía nix-darwin**, si `darwin-system-config` ya está aplicado: el cambio declarativo es la fuente de verdad y la reconstrucción del sistema restaura los dominios declarados. Esto no aplica a las escrituras **host-scoped** (`-currentHost`), que son fuera del alcance de `system.defaults` y por lo tanto no son restaurables por nix-darwin.

**Disciplina de diff — dos reglas duras:**

1. **El diff no toca ningún otro módulo.** Solo `zsh/modules/osx/**` (nuevo) y las 2 líneas del `Taskfile.yml` raíz. Si el diff muestra cualquier otro módulo, es un error — se revierte antes de commitear.
2. **`zsh/modules/ai/` tiene cambios sin commitear anteriores a este trabajo y no deben mezclarse.** Esos cambios son preexistentes y no tienen relación con `add-osx-module`. Mezclarlos en estos commits metería código no revisado y no relacionado en un change cuya premisa es "puramente aditivo y no toca ningún otro módulo". **Antes de commitear, stagear explícitamente los paths de este change** (`git add zsh/modules/osx/ Taskfile.yml`) y verificar con `git diff --cached --stat` que `zsh/modules/ai/` **no** aparece.

## Open Questions

Ninguna. Todo lo que queda abierto en este change está decidido acá o pertenece al contrato de comportamiento en `specs/osx-module/spec.md`.
