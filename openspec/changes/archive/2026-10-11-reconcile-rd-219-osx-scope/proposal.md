# Proposal

## Why

RD-219 ya está implementado y archivado: `zsh/modules/osx/` existe con 21 archivos, el cambio `2026-09-28-add-osx-module` está archivado con 40/40 tareas y `openspec/specs/osx-module/spec.md` ya está sincronizado. El problema no es el módulo: son **tres fuentes de verdad que ya no concuerdan**.

- **Fuente A — la spec principal archivada (`openspec/specs/osx-module/spec.md`), CORRECTA.** Acota el módulo deliberadamente: solo el residuo que la configuración declarativa no puede expresar — escrituras con scope de host, operaciones privilegiadas degradadas a procedimientos manuales documentados, operaciones destructivas con gate, refresh explícito de runtime y reporte de drift de screen-lock. Su Propósito dice textualmente que los ~150 defaults declarativos de dominio de usuario NO pertenecen a esta capability: son de `darwin-system-config`.
- **Fuente B — el doc de requisitos del ticket (`.codi/jira/RD-219/requirements/RD-219.md`), OBSOLETO y contradice a A.** Exige migrar los 171 `defaults write` al módulo (criterio 8), contradiciendo la postergación de A; especifica una descomposición en 14 archivos `internal/<area>.zsh` cuando se entregaron 5 archivos por concern de ciclo de vida (`host`, `privileged`, `destructive`, `refresh`, `screenlock`, sin `internal/base.zsh` ni dispatch de OS — divergencia documentada y deliberada); declara 13 `sudo` cuando la verdad medida es 12; declara 4 `scutil --set` cuando son 3 (NetBIOSName en la línea 501 es un `sudo defaults write` al plist de SMB); declara 3 funciones públicas cuando son 4 (`osx::packages` también es pública, stub de mensajes).
- **Fuente C — el artefacto entregado (`zsh/modules/osx/data/migration-inventory.yaml`), MAYORMENTE CORRECTO.** Inventario YAML versionado de 2.909 líneas, `schema_version: 1`, anclado a `source_commit: 79b1243530b34e5f5f09fb78d38d67c8afbb01d3`. Una auditoría independiente contra la fuente externa lo confirmó correcto en todos los censos titulares: 171 escrituras = 158 planas + 7 sudo + 6 `-currentHost`, más 1 `defaults delete`; 12 operaciones privilegiadas (anotando explícitamente "not 13"); 3 `scutil --set` con NetBIOS correctamente tipeado como defaults write; 29 pares `(domain,key)` duplicados de los cuales 7 son conflictos reales; COMPUTER_NAME 4 referencias / 0 asignaciones; el orden exacto de `osx::sync` de 15 entradas. Hasta corrige tres errores de RD-219 en su propio bloque `metadata.ticket_corrections`.

Pero tiene defectos que importan:

1. **Exactitud de datos (Medium).** `metadata.source_file_lines: 588` y el comentario de cabecera `base.zsh (588 lines)` son falsos: la fuente tiene 589 líneas lógicas; `wc -l` da 588 solo porque el archivo no tiene newline final. El inventario se contradice a sí mismo con su propio `source_sync_order_source: zsh-osx/internal/base.zsh:573-589`. Esto daña el contrato declarado del artefacto: "los números aquí se re-derivan de la fuente, no se copian del ticket".
2. **Integridad de datos (Medium — el serio).** `write_call_census.delete.effect` afirma que el `defaults delete` de la línea 134 "deshace" los 13 writes de `ApplePressAndHoldEnabled` en las líneas 106-132. Falso: el delete es de dominio global (`-g`, NSGlobalDomain) y solo puede deshacer los 2 writes de NSGlobalDomain en las líneas 106 y 108. Los otros 11 writes están en dominios de APP (VSCode ×4, JetBrains ×3, iTerm2, Insomnia, Brave, Android Studio) y **persisten como `-bool false`**. El propio `deferred_to_darwin_system_config.by_domain` del inventario lo prueba, así que dos secciones del mismo artefacto se contradicen; la afirmación se repite en `notes[0]`. Consecuencia: un consumidor que implemente el "net effect es unset" documentado descarta en silencio 11 settings de dominio de app — exactamente la clase de pérdida de fidelidad que el artefacto existe para prevenir.
3. **Completitud (Medium).** La dependencia transitiva crítica solo está en prosa. `osx::sync` invoca 15 funciones de área en orden fijo, pero `osx::keyboard` además llama a `osx::vim::keyboard` en la línea 97 de la fuente. `osx::vim::keyboard` NO es miembro de `source_sync_order`. 14 invocaciones de `defaults` (13 writes + 1 delete — todo el bloque ApplePressAndHoldEnabled) cuelgan de esa llamada indirecta. Un lector máquina que consuma `source_sync_order` — el campo más probable de consumirse programáticamente — recibe 15 nombres y cero señal de que la posición 3 arrastra una función no listada. Reexpresar esa lista a ciegas pierde el bloque entero.
4. **(Bajo).** `README.yaml` y el `README.md` generado dicen "roughly 150 declarative user-domain defaults", que no coincide ni con el censo propio del inventario (130 claves únicas en 164 llamadas de escritura no privilegiadas) ni con nada más del repo.
5. **(Bajo, higiene de esquema).** `total_write_calls` significa 171 bajo `write_call_census` pero 164 bajo `deferred_to_darwin_system_config` — ambos correctos en contexto, peligrosos para un lector máquina por nombre de campo. Además `value_signatures` es un set deduplicado y ordenado que NO está alineado línea a línea con `source_lines` (ApplePressAndHoldEnabled tiene valores `[true, false]` en las líneas 106,108 pero `value_signatures` `[false, true]`), así que un consumidor que haga zip de ambos campos mapea mal los ganadores.

**La brecha real que esto expone:** los ~150 defaults de dominio de usuario postergados hoy NO los configura nada. Su hogar designado, la capability `darwin-system-config`, no tiene spec principal — existe solo como delta spec sin archivar dentro del cambio todavía activo `nix-darwin-support`, que va en 0 de 33 tareas. RD-219 se marcó "completo" mientras su componente de scope más grande no aterrizó en ninguna parte. Este cambio NO arregla esa postergación; la hace precisa y trazable para que la brecha deje de ser invisible.

## What Changes

- Corregir `metadata.source_file_lines` y el comentario de cabecera de 588 a 589 en `zsh/modules/osx/data/migration-inventory.yaml`.
- Reformular `write_call_census.delete.effect` y `notes[0]` acotando el delete correctamente: solo deshace los 2 writes de NSGlobalDomain (líneas 106, 108); los 11 writes de dominios de app (110-132) persisten como `-bool false`.
- Promover la dependencia transitiva `osx::vim::keyboard` de prosa a datos estructurados, legibles por máquina, en el inventario: llamador, llamado, línea 97 de la fuente, las 14 invocaciones de `defaults` que arrastra, y el hecho de que NO está en `source_sync_order`.
- Reconciliar la cifra de "roughly 150" en `zsh/modules/osx/README.yaml` (y regenerar `README.md` desde él) con el censo propio del inventario: 130 claves únicas / 164 llamadas de escritura.
- Resolver la colisión de nombre `total_write_calls` y la no-alineación de `value_signatures` como hazards de esquema documentados.
- Reconciliar el doc de requisitos obsoleto `.codi/jira/RD-219/requirements/RD-219.md` contra el scope entregado: la decisión de acotar a residuo, la descomposición en 5 archivos por concern de ciclo de vida que se entregó en lugar de 14 archivos de área, y los tres conteos corregidos (sudo 12 no 13, scutil 3 no 4, 4 funciones públicas no 3).

## Capabilities

### New Capabilities

Ninguna capability nueva. Este cambio no introduce comportamiento duradero del sistema: nombra el trabajo de reconciliación, no una capability.

### Modified Capabilities

- `osx-module`: la requirement "Inventario de migración versionado" cambia. Sus escenarios actuales exigen que el inventario registre el censo de escrituras, las claves duplicadas/conflictivas, la variable sin asignar y el orden de invocación del origen. Este cambio endurece esa requirement para que los datos registrados deban ser precisos en su **scope** — no solo presentes — y para que las llamadas indirectas (transitivas) del orden de origen se registren estructuralmente, no solo como prosa.

## Impact

- `zsh/modules/osx/data/migration-inventory.yaml` — el bump de `schema_version` es una decisión que debe tomarse explícitamente: el artefacto documenta que un consumidor "should fail loudly on schema_version != 1". Si se hace el bump, se requiere una decisión de manejo lado-consumidor, y es un riesgo si no se decide deliberadamente; si no se hace, el esquema se corrige dentro de v1 y la promesa de "fail loudly" queda intacta. Resolver en design.md.
- `zsh/modules/osx/README.yaml` y el `zsh/modules/osx/README.md` generado — `README.md` es GENERADO, nunca se edita a mano; lo produce `task module-osx:readme` vía gomplate desde `README.yaml` + `provision/templates/README.module.tpl.md`.
- `.codi/jira/RD-219/requirements/RD-219.md` — el doc de requisitos obsoleto que contradice a la spec principal archivada.
- Consumidor aguas abajo `darwin-system-config` (cambio `nix-darwin-support`, 0/33 tareas) — consume este inventario; el Defecto 2 hoy lo engaña.
- Sin cambios en el comportamiento runtime del módulo. `zsh/modules/osx/internal/*.zsh` y `pkg/*.zsh` NO se tocan — esto es solo un cambio de datos y documentación.
