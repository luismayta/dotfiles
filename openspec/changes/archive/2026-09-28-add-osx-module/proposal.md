## Why

`luismayta/zsh-osx` es un plugin externo cuyo único contenido funcional son 588 líneas de `defaults write` que configuran macOS: 21 funciones y 171 llamadas de escritura, todas en `zsh-osx/internal/base.zsh`. Pero en este repo `grep -rln "defaults write" zsh/` devuelve cero resultados y `zsh/modules/osx/` no existe: la configuración de sistema macOS no existe en ningún lado.

El cambio activo `nix-darwin-support` (sin mergear) ya declara la capability `darwin-system-config`, cuyo propósito es configurar los defaults de macOS (Dock, Finder, screenshots) vía `system.defaults`. La decisión es explícita: **`osx` queda scopeado a solo lo que nix-darwin no puede expresar declarativamente.** Las ~150 claves declarativas de dominio de usuario (NSGlobalDomain, `com.apple.finder`, `com.apple.dock`, `com.apple.Safari`, y los dominios por app de VSCode, JetBrains, Brave, Insomnia, Android Studio, iTerm2) quedan fuera de scope y son territorio de `darwin-system-config`.

Por lo tanto este módulo no es "las 588 líneas migradas": es un módulo chico y afilado para el residuo — escrituras host-scoped, privilegiadas que degradan a no-op, destructivas gateadas, un puente de refresco en runtime y la política de screen-lock reportada en vez de escrita. La superficie de código es pequeña a propósito; el trabajo caro es el análisis, y ese análisis se preserva como artefacto.

## What Changes

### En scope

1. **Escrituras host-scoped** — 6 llamadas `defaults -currentHost write` (`zsh-osx/internal/base.zsh:45`, `:161`, `:167`, `:168`, `:172`, `:510`). Las líneas 45 y 510 escriben la misma clave (`com.apple.ImageCapture disableHotPlug`) y se deduplican a una. Las otras cuatro se enumeran y clasifican durante la implementación, no se afirman acá.

2. **Operaciones privilegiadas — las 12 degradan a no-op con `message_warning`.** Nunca se ejecuta `sudo`; es decisión del usuario. Las 6 en `automatic-updates` (`zsh-osx/internal/base.zsh:363-368`: 5 escrituras en `/Library/Preferences/com.apple.SoftwareUpdate.plist` — `AutomaticallyInstallMacOSUpdates`, `AutomaticCheckEnabled`, `AutomaticDownload`, `ConfigDataInstall`, `CriticalUpdateInstall` — más `AutoUpdate` en `/Library/Preferences/com.apple.commerce.plist`); `sudo nvram SystemAudioVolume=" "` (`:482`); `sudo systemsetup -setrestartfreeze on` (`:488`); y `zsh-osx/internal/base.zsh:498-501` con 3 × `sudo scutil --set` (`ComputerName`, `HostName`, `LocalHostName`) más 1 × `sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName`. Cada una se convierte en un procedimiento manual documentado más un `message_warning` que declara el paso manual.

3. **Operaciones destructivas — ambas gateadas, nunca corren en un sync normal.**
   - `zsh-osx/internal/base.zsh:38` — `lsregister -kill -r -domain local -domain system -domain user`, que reconstruye Launch Services en tres dominios. Detrás de un flag de opt-in explícito. Nota: `core::confirm` no existe en este repo; el precedente es el helper local `_cleanup::confirm` en `zsh/modules/clean/internal/base.zsh`, gateado por `ZSH_CLEAN_CONFIRM` / `ZSH_CLEAN_FORCE`. El módulo `osx` replica esa forma con sus propias gates.
   - `zsh-osx/internal/base.zsh:320-323` — `com.apple.dock static-only -bool true` seguido de `com.apple.dock persistent-apps -array`, que borra todos los iconos del Dock sin backup (el propio comentario del source lo dice). Requiere confirmación explícita o se descarta.

4. **Puente de refresco en runtime** — `killall Finder` (`zsh-osx/internal/base.zsh:306`) y `killall Dock` (`zsh-osx/internal/base.zsh:412`). nix-darwin no puede reiniciar las apps corriendo tras aplicar la config, así que hacer que la sesión viva refleje lo declarativo es exactamente el hueco que `osx` cubre. Es su propuesta de valor central.

5. **Política de screen-lock: detectar y reportar** — `com.apple.screensaver askForPassword` (`zsh-osx/internal/base.zsh:183`, `:353`) y `askForPasswordDelay` (`:184` = `-int 0`, `:354` = `-int 5`). Los dos valores se contradicen y el resultado efectivo depende del orden de invocación: un defecto. Según el benchmark CIS Ventura Apple macOS 13, el camino oficial ya no es `defaults write` sino `sysadminctl -screenLock` o un perfil MDM. El módulo reporta el drift y documenta la ruta soportada; no escribe en silencio una clave deprecada.

6. **Scaffold estándar de tres capas** — el módulo sigue la arquitectura de `docs/guides/create-module.md`. `zsh/zshrc:57` itera `${DOTFILES_ZSH_PATH}/modules/*(/N)` y sourcea cualquier `plugin.zsh`, así que crear el directorio basta: no hay registro que mantener en `zshrc`.

### Fuera de scope

- **Las ~150 claves declarativas de dominio de usuario** (las de arriba) → `darwin-system-config`.
- **Paquetes/casks.** `osx::packages` (`zsh-osx/internal/base.zsh:557`) es un stub muerto con cero callers en todo el source, y `zsh/modules/apps/` ya implementa instalación de casks por plataforma con `core::ensure`. No se migra; el módulo documenta la delegación a `apps::packages::install`.
- **Configuración de git.** `zsh-osx/internal/base.zsh:473` escribe `git config --global alias.lastchange`; un módulo de settings de macOS no debe escribir el `~/.gitconfig` del usuario. No se migra.

### Entregable: inventario de migración

Como ~150 claves se difieren a nix-darwin, el análisis caro no se puede perder. Este cambio entrega un **documento de inventario de migración** que `darwin-system-config` consumirá como input: un artefacto versionado del módulo, bajo `zsh/modules/osx/data/`. Es la razón por la que este trabajo vale la pena pese a la superficie de código pequeña.

### Hechos corregidos del source

- 171 escrituras = 158 `defaults write` planos + 7 `sudo defaults write` + 6 `defaults -currentHost write`; más 1 `defaults delete` (`zsh-osx/internal/base.zsh:134`).
- **12** llamadas `sudo`, no 13: `zsh-osx/internal/base.zsh:363-368`, `:482`, `:488`, `:498-501`.
- **29** pares `(domain, key)` duplicados. De esos, **7 tienen valores conflictivos**: `NSGlobalDomain ApplePressAndHoldEnabled` (`:106` `true` vs `:108` `false`, borrada en `:134` — 13 escrituras deshechas); `com.apple.screensaver askForPasswordDelay` (`:184` `0` vs `:354` `5`); `com.apple.finder FXPreferredViewStyle` (`:207` `"Nlsv"` vs `:242` `"clmv"` — el comentario del source en `:206` dice "use list view", así que se derrota a sí mismo); y 4 hot corners: `wvous-tr-corner` (`:345` `5` vs `:402` `2`), `wvous-tr-modifier` (`:346` `1048576` vs `:403` `0`), `wvous-br-corner` (`:349` `6` vs `:409` `4`), `wvous-br-modifier` (`:350` `1048576` vs `:410` `0`).
- `COMPUTER_NAME` aparece 4 veces y las 4 son usos: cero asignación. Las 4 llamadas `scutil`/`NetBIOSName` dejarían el hostname vacío. Bug confirmado.
- 5 claves muertas contra macOS moderno: `com.apple.menuextra.battery ShowPercent` (`:17`, muerta desde Big Sur 11; el reemplazo es `defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true`); `com.apple.Finder` con F mayúscula (`:222`, dominio legacy pre-Mavericks; el correcto es `com.apple.finder` en minúscula); `com.apple.dashboard mcx-disabled` (`:336` y `:379`, Dashboard se eliminó en Catalina 10.15); `com.apple.dock dashboard-in-overlay` (`:339` — es el dominio `dock`, no `dashboard`); `com.apple.BezelServices kDimTime` (`:156`, backlight pre-2016, inoperante en Apple Silicon).
- 1 clave cuyo mecanismo cambió: `com.apple.Safari IncludeDevelopMenu` está en `zsh-osx/internal/base.zsh:443` y dejó de funcionar por sí sola en Safari 15 / macOS 12 — requiere además `com.apple.Safari.SandboxBroker ShowDevelopMenu` y Full Disk Access para la terminal. (`:434` es otra clave, `IncludeInternalDebugMenu`.)
- Orden de `osx::sync`, preservado en el inventario porque el orden decide qué valor gana: ux, appStore, keyboard, trackpad, screen, finder, dock, mail, spotlight, automaticUpdates, missioncontrol, browser, messages, extras, others.
- El idioma de mensajería del source es `message_info` / `message_success` únicamente — sin `echo`, sin `printf`. `osx::sync` no emite nada; toda la salida viene de las callees.

## Capabilities

### New Capabilities

- `osx-module`: Módulo zsh en `zsh/modules/osx/` que cubre solo las operaciones de macOS que la configuración declarativa no puede expresar — escrituras host-scoped (`defaults -currentHost`), operaciones privilegiadas degradadas a procedimientos manuales, operaciones destructivas gateadas, refresco de procesos en runtime, y reporte de drift de screen-lock. Los ~150 defaults declarativos de dominio de usuario NO pertenecen a esta capability: son de `darwin-system-config` (cambio `nix-darwin-support`). Incluye un inventario de migración versionado que ese change consumirá como input.

### Modified Capabilities

<!-- Ninguna: este módulo es puramente aditivo y no altera comportamiento existente; `darwin-system-config` sigue declarándose en `nix-darwin-support`. -->

## Impact

- **Archivos afectados:**
  - `Taskfile.yml` — dos ediciones: include `module-osx:` entre `module-notify` (líneas 110-111) y `module-nvim` (112-113), y `- task: module-osx:readme` en `readme:modules` (281-325)
  - `zsh/modules/osx/` — módulo nuevo (descubrimiento automático vía `zsh/zshrc:57`, sin registro que mantener)
  - `zsh/modules/osx/data/` — inventario de migración versionado, entregable de este cambio
- **Ningún otro módulo se toca.** `zsh/modules/ai/` tiene cambios sin commitear anteriores a este trabajo y no deben mezclarse en estos commits.
- **Acoplamiento con nix-darwin:** el módulo está deliberadamente atado a que `nix-darwin-support` aterrice. Si ese cambio se abandona, el módulo entrega solo un residuo pequeño y las ~150 claves declarativas quedan sin migrar. Ese acoplamiento es el trade aceptado para no tener dos fuentes de verdad compitiendo por los defaults de macOS.
- **Red de seguridad:** el inventario del source es la cobertura — si nix-darwin nunca aterrice, el documento sigue siendo un artefacto correcto y reutilizable.
- **Desactivación:** vía `ZSH_DISABLED_MODULES` y `ZSH_OSX_ENABLED=false` en Linux — ningún cambio en el comportamiento actual de Linux.
- **Sin `BREAKING`:** puramente aditivo.
