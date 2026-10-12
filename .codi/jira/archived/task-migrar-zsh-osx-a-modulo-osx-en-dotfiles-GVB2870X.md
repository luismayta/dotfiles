# Task: Migrar zsh-osx al nuevo módulo osx de dotfiles

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Migrar las 588 líneas de defaults write de zsh-osx al nuevo módulo zsh/modules/osx de dotfiles
- component: DevOps
- labels: [zsh, macos, osx, migration, module]
- parentEpic: 
- issueKey: RD-219
- jpdSource: 

## Scenario

## Contexto

`luismayta/zsh-osx` es un plugin de zsh cuyo único contenido funcional son
588 líneas de `defaults write` que configuran macOS: 21 funciones, 171
llamadas, repartidas en `internal/base.zsh`. El resto del repo es andamiaje
hadenlabs: 13 de sus 20 archivos `.zsh` son stubs de 1-3 líneas, y
`docs/components.md` y `docs/functions.md` están vacíos.

En dotfiles **no existe nada equivalente**: `grep -rln "defaults write"
zsh/` devuelve cero resultados. La configuración de macOS del sistema no
está en ningún módulo de `zsh/modules/`. Esta migración aporta 588 líneas de
capacidad que hoy no existen en ninguna parte del repo.

`zsh/modules/osx/` no existe todavía. `zsh/zshrc:57-66` descubre módulos por
iteración de directorio sobre `modules/*(/N)`, así que crear `plugin.zsh`
basta para que cargue — no hay registro que mantener. `ZSH_DISABLED_MODULES`
permite desactivarlo con `export ZSH_DISABLED_MODULES="osx"`.

## Origen de la convención

La guía `docs/guides/create-module.md` (779 líneas, frontmatter
`type: Guide`) define la arquitectura de tres capas y el scaffold de 18
archivos. Cita `zsh/modules/zed/` como implementación de referencia.
`docs/guides/implement-module-update.md` cubre el patrón de sub-archivos
`internal/<area>.zsh` que se usa aquí.

Estas guías son markdown con frontmatter, NO skills de opencode ni comandos
invocables con `/nombre`. Se citan por ruta.

## Decisiones de diseño tomadas

**Nombre del módulo: `osx`.** Directorio `zsh/modules/osx/`, guard
`__ZSH_OSX_LOADED`, `ZSH_OSX_PATH="${0:A:h}"`, `ZSH_OSX_ENABLED`,
`ZSH_OSX_PACKAGE_NAME`, `ZSH_OSX_DATA_PATH`.

**Namespace: se reutiliza el prefijo `osx::` que ya usa zsh-osx, sin
renombrar 21 funciones.** El mapeo es directo a las tres capas de la guía:
las 18 funciones privadas pasan de `osx::<fn>` a `osx::internal::<fn>`, con
`osx::vim::keyboard` mapeando a `osx::internal::vim::keyboard` (el patrón
`<name>::internal::<area>::<verb>` de la guía). Las públicas `install`,
`post_install` y `sync` pasan a `pkg/`. No hay colisión: el prefijo del
módulo ES `osx::`, igual que el del repo de origen.

**División de `internal/base.zsh` en 14 archivos por área**, siguiendo el
patrón `internal/<area>.zsh` de `implement-module-update.md` y el precedente
de `apps/internal/webapp.zsh`. Un solo archivo de 588 líneas es deuda de
mantenimiento; los groupings de funciones ya existen y mapean 1:1:
`ux`, `appstore`, `keyboard`, `trackpad`, `screen`, `finder`, `dock`,
`automatic-updates`, `mission-control`, `browser`, `messages`, `mail`,
`spotlight`, `others`. Se sourcean desde `internal/main.zsh` antes del
dispatch por SO, igual que `apps` hace con `webapp.zsh`.

**`osx::packages` se descarta, no se migra.** En zsh-osx es un stub que solo
imprime mensajes. Y `zsh/modules/apps/` YA implementa esto correctamente con
`core::ensure` sobre arrays de casks por plataforma. Duplicarlo sería
violar el "Core Reuse" de la guía. El módulo `osx` documenta la delegación a
`apps::packages::install` y no lo reimplementa.

**`config/linux.zsh` fija `ZSH_OSX_ENABLED=false`**, con el patrón exacto de
`hyprland/config/osx.zsh` y `waybar/config/osx.zsh`. `defaults write` no
existe en Linux; el módulo es macOS-only por naturaleza, no por decisión.

## Defectos que la migración debe corregir

No es una copia ciega. `zsh-osx` no toca código desde el 12 de mayo de 2025 y
arrastra defectos que no deben llegar a `main`:

- **`COMPUTER_NAME` no está definido en ningún sitio del repo de origen.**
  Las 4 llamadas `sudo scutil --set` de `:498-501` (ComputerName, HostName,
  LocalHostName y NetBIOSName en el plist de SMB) intentarán fijar un
  hostname vacío. Se define o se eliminan.
- **7 conflictos de clave activos.** `ApplePressAndHoldEnabled` se escribe 13
  veces y luego `:134` la borra, deshaciendo todo. `FXPreferredViewStyle`:
  `"Nlsv"` (`:207`) vs `"clmv"` (`:242`) — el módulo se contradice a sí
  mismo. `wvous-tr-corner` `5` (`:345`) vs `2` (`:402`);
  `wvous-tr-modifier` `1048576` (`:346`) vs `0` (`:403`);
  `wvous-br-corner` `6` (`:349`) vs `4` (`:409`);
  `wvous-br-modifier` `1048576` (`:350`) vs `0` (`:410`);
  `askForPasswordDelay` `0` (`:184`) vs `5` (`:354`), donde el 5 gana por el
  orden de `osx::sync`.
- **4 claves muertas confirmadas con fuente.**
  `com.apple.menuextra.battery ShowPercent` (`:17`) — muerta desde Big Sur
  11; el reemplazo es `defaults -currentHost write com.apple.controlcenter
  BatteryShowPercentage -bool true`. `com.apple.Finder` (`:222`, F mayúscula)
  — dominio legacy anterior a Mavericks; el correcto es `com.apple.finder`.
  `com.apple.dashboard mcx-disabled` (`:336`, `:379`) y
  `dashboard-in-overlay` (`:339`) — Dashboard fue eliminado en Catalina
  10.15. `com.apple.BezelServices kDimTime` (`:156`) — retroiluminación
  pre-2016, inoperante en Apple Silicon.
- **2 claves cuyo mecanismo cambió.** `com.apple.screensaver
  askForPassword` / `askForPasswordDelay` (`:183-184`, `:353-354`): la vía
  oficial ya no es `defaults write` sino `sysadminctl -screenLock` o perfil
  MDM, según el benchmark CIS Ventura. `com.apple.Safari
  IncludeDevelopMenu` (`:434`): dejó de funcionar por sí solo en Safari 15 /
  macOS 12; requiere además `com.apple.Safari.SandboxBroker
  ShowDevelopMenu` y Full Disk Access para Terminal.
- **`:473` `git config --global alias.lastchange`** — escribe en el
  `~/.gitconfig` del usuario, fuera del ámbito de macOS. Se elimina, no se
  migra.
- **`:323` `persistent-apps -array`** borra el Dock completo sin backup.
  Necesita confirmación explícita del usuario.
- **`:38` `lsregister -kill -r`** reconstruye Launch Services en los dominios
  local, system y user. Es nuclear y debe ir gateado.
- **El comentario en `:105` dice "Disable press-and-hold" mientras el valor
  `:106` es `-bool true`, que lo habilita.**
- **13 llamadas `sudo`**, incluida `:482` (`nvram SystemAudioVolume`) y
  `:488` (`systemsetup -setrestartfreeze`). Cada una necesita justificación
  en comentario, o se degrada a no-op con `message_warning` cuando faltan
  privilegios.

23 claves duplicadas con el mismo valor también se consolidan
(`NSAutomaticQuoteSubstitutionEnabled` en `:41`, `:51`, `:90`;
`com.apple.dock/expose-animation-duration` en `:331` y `:378`).

### Acceptance Tests

## Scaffold (los 18 archivos de la guía existen)

1. `zsh/modules/osx/` con `plugin.zsh`, `config/{base,main,osx,linux}.zsh`,
   `internal/{base,main,osx,linux}.zsh`,
   `pkg/{base,main,osx,linux,helper,alias}.zsh`, `data/`, `README.yaml` y
   `Taskfile.yml`. `pkg/alias.zsh` existe aunque esté vacío — la guía lo exige
   para que `pkg/main.zsh` pueda sourcearlo incondicionalmente.
2. `plugin.zsh` con el guard `__ZSH_OSX_LOADED`,
   `ZSH_OSX_PATH="${0:A:h}"`, y la cadena
   `config/main.zsh` → `$ZSH_OSX_ENABLED || return` → `internal/main.zsh` →
   `pkg/main.zsh`, con `# shellcheck source=/dev/null` antes de cada
   `source`.
3. `config/base.zsh` declara `ZSH_OSX_ENABLED="${ZSH_OSX_ENABLED:-true}"` y
   `export ZSH_OSX_PACKAGE_NAME=osx`. Usa el prefijo `ZSH_OSX_` que exige la
   sección 8 de la guía, NO el patrón legacy sin prefijo que usan
   `starship`, `nvim` y `apps`.
4. `config/linux.zsh` fija `ZSH_OSX_ENABLED=false` con el patrón de
   `hyprland/config/osx.zsh`.
5. Los 14 archivos `internal/<area>.zsh` existen, se sourcean desde
   `internal/main.zsh` antes del dispatch por SO, y usan prefijo
   `osx::internal::`. `osx::internal::vim::keyboard` para el sub-área.

## Registro

6. El `Taskfile.yml` raíz registra `module-osx:` con
   `taskfile: ./zsh/modules/osx/Taskfile.yml`, y la tarea agregada de
   `readme` incluye `task: module-osx:readme`. Sin esas dos entradas el
   README no se genera.
7. `README.md` se genera con `task module-osx:readme` desde `README.yaml` +
   `provision/templates/README.module.tpl.md`. `README.yaml` sigue el schema
   de `zsh/modules/apps/README.yaml` (name, tags, license, github_repo,
   description, features, requirements) y declara que el módulo es
   macOS-only.

## Fidelidad de la migración

8. Las 171 llamadas `defaults write` están migradas, salvo las eliminadas
   por los criterios de limpieza. Cada una queda en su archivo de área.
9. Las 18 funciones privadas usan `osx::internal::<fn>`. Las 3 públicas
   (`install`, `post_install`, `sync`) viven en `pkg/base.zsh` como wrappers
   finos.
10. `osx::sync` conserva el orden de invocación del origen: ux, appStore,
    keyboard, trackpad, screen, finder, dock, mail, spotlight,
    automaticUpdates, missioncontrol, browser, messages, extras, others. El
    orden define qué gana en los conflictos, así que cambiarlo cambia el
    comportamiento.
11. `osx::packages` NO se migra. El módulo documenta la delegación a
    `apps::packages::install` de `zsh/modules/apps/`, que ya usa `core::ensure`.

## Limpieza (esto no es una copia ciega)

12. `COMPUTER_NAME` queda definido, o las 4 llamadas `scutil` de `:498-501` se
    eliminan. Si se conservan, probadas con un nombre real.
13. Los 7 conflictos de clave quedan resueltos: una sola intención por clave,
    con la razón documentada de cuál gana y por qué.
14. `ApplePressAndHoldEnabled` deja de escribirse 13 veces para ser borrada:
    se elige `write` o `delete` y se aplica una vez.
15. Las 23 claves duplicadas se consolidan en su archivo de área propietario.
16. `com.apple.Finder` (`:222`) pasa a `com.apple.finder`.
17. `com.apple.menuextra.battery ShowPercent` (`:17`) se sustituye por
    `defaults -currentHost write com.apple.controlcenter
    BatteryShowPercentage -bool true`.
18. Las claves de `com.apple.dashboard` (`:336`, `:339`, `:379`) se eliminan y
    los hot corners que apuntaban a Dashboard se reasignan o se retiran.
19. `com.apple.BezelServices kDimTime` (`:156`) se elimina, confirmando
    primero que no aplica a Apple Silicon.
20. `askForPassword` / `askForPasswordDelay` migran a `sysadminctl
    -screenLock` o se documentan como requieren MDM.
21. `IncludeDevelopMenu` (`:434`) se acompaña de
    `com.apple.Safari.SandboxBroker ShowDevelopMenu` y se documenta el
    requisito de Full Disk Access.
22. `git config --global` de `:473` no se migra. Un módulo de macOS no escribe
    en el `~/.gitconfig` del usuario.
23. `persistent-apps -array` (`:323`) exige confirmación explícita del usuario
    antes de ejecutarse, o se elimina.
24. `lsregister -kill -r` (`:38`) queda gateado detrás de un flag, no se
    ejecuta en cada `osx::sync`.
25. El comentario contradictorio de `:105-106` se corrige para describir lo
    que el valor realmente hace.
26. Las 13 llamadas `sudo` están justificadas una por una en comentario, o se
    degradan a no-op con `message_warning` cuando faltan privilegios.

## Conformidad con la guía

27. Todo el output usa `message_info` / `message_success` / `message_error` /
    `message_warning`. Cero `echo`, cero `printf`.
28. Las comprobaciones de binario usan `core::exists` / `core::ensure`. Cero
    `which`, cero `command -v`.
29. Ninguna reimplementación de `core::install`, `core::exists` ni
    `message_*`.
30. Los archivos de módulo empiezan con shebang `#!/usr/bin/env ksh` +
    `# -*- coding: utf-8 -*-`, como el resto de módulos.

## Verificación

31. `source zsh/system/core/main.zsh && source zsh/modules/osx/plugin.zsh`
    no produce errores, y el mensaje "Loading module: osx" aparece UNA sola
    vez al hacer doble source (verificación del guard).
32. `type osx::install`, `type osx::sync` y `type osx::setup` devuelven
    "function".
33. Sobre Linux, `source zsh/modules/osx/plugin.zsh` no ejecuta ninguna
    función de `defaults` (por el guard `ZSH_OSX_ENABLED=false`).
34. `export ZSH_DISABLED_MODULES="osx"` antes del loop de módulos evita la
    carga, sin error.
35. `pre-commit run --all-files` pasa con shellcheck
    (`--exclude=SC1072,SC1073,SC2068`).
36. El diff no toca ningún otro módulo. `zsh/modules/ai/` tiene cambios
    sin commitear previos a esta task — no mezclarlos en los commits.

## Commits

37. Conventional Commits con scope y emoji,división en commits lógicos — no
    un commit de 588 líneas. Orden sugerido: scaffold, luego un commit por
    área, luego limpieza de claves muertas, luego los conflictos.
38. Se usa `goji-commit-smart`, como el resto del repo. Cada mensaje incluye
    la key de Jira.
39. Se documenta en el README del módulo que `luismayta/zsh-osx` es el origen
    histórico y queda deprecado, decidiendo explícitamente si se archiva o se
    marca como superseded por este módulo.

### Sources

* `/home/lucho/Projects/src/github.com/luismayta/zsh-osx/internal/base.zsh` —
  las 588 líneas a migrar. `:498-501` el bug de `COMPUTER_NAME`, `:573-589`
  el orden de `osx::sync`, `:105-106` el comentario contradictorio
* `/home/lucho/Projects/src/github.com/luismayta/zsh-osx/zsh-osx.zsh:11-23` —
  entrypoint actual, source lineal de 4 capas
* `docs/guides/create-module.md` — arquitectura de tres capas, scaffold de 18
  archivos, sección 8 de naming conventions, checklist. Cita
  `zsh/modules/zed/` como referencia canónica
* `docs/guides/implement-module-update.md` — patrón `internal/<area>.zsh`
* `zsh/zshrc:57-66` — descubrimiento automático por iteración de directorio
* `zsh/system/core/pkg/base.zsh` — implementación de `message_*`
* `zsh/modules/zed/` — implementación de referencia de la guía
* `zsh/modules/apps/` — precedente más cercano en naturaleza: arrays de
  casks por plataforma, `internal/webapp.zsh` como sub-área
* `zsh/modules/hyprland/config/osx.zsh` y `zsh/modules/waybar/config/osx.zsh`
  — patrón de módulo deshabilitado por plataforma
* `zsh/modules/ghq/config/base.zsh:7,22` — patrón de
  `ZSH_<NAME>_PACKAGE_NAME` con alias backward-compat
* `Taskfile.yml:66-67,112-113,128-129,288-320` — dónde registrar
  `module-osx:` y la tarea `readme` agregada
* `zsh/modules/README.md` — boilerplate genérico, NO es un índice de módulos;
  no requiere actualización
* macOS 27 Golden Gate, 14 sep 2026 —
  https://www.macrumors.com/2026/09/14/apple-releases-macos-golden-gate
* `man defaults` — "If the file does not exist, it will be created"
  (deprecación silenciosa) — https://keith.github.io/xcode-man-pages/defaults.1.html
* `com.apple.menuextra.battery ShowPercent` muerto desde Big Sur 11 —
  https://mynixos.com/home-manager/option/targets.darwin.defaults.%22com.apple.menuextra.battery%22.ShowPercent
* Reemplazo `com.apple.controlcenter BatteryShowPercentage` verificado en
  Sequoia — https://github.com/mathiasbynens/dotfiles/issues/701
* `com.apple.dock dashboard-in-overlay` muerto en Catalina 10.15 —
  https://en.wikipedia.org/wiki/Mission_Control_(macOS)
* `askForPassword` → `sysadminctl -screenLock` (CIS Ventura no lista
  `defaults write`) — https://www.tenable.com/audits/items/CIS_Apple_macOS_13.0_Ventura_v2.0.0_L1.audit
* `IncludeDevelopMenu` requiere SandboxBroker desde Safari 15 —
  https://apple.stackexchange.com/questions/429814
* TCC bloquea escritura CLI en ciertos dominios desde macOS 14/26 —
  https://github.com/nix-darwin/nix-darwin/issues/1049
- https://github.com/luismayta/dotfiles.git