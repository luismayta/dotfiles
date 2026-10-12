# Design

## Context

RD-219 ya está implementado y archivado; este cambio no toca código runtime (`zsh/modules/osx/internal/*.zsh` y `pkg/*.zsh` quedan intactos) — solo datos y documentación. La motivación completa (las tres fuentes de verdad que divergen) vive en `proposal.md — Why`; lo que sigue es solo el estado que moldea el enfoque:

- **El artefacto** `zsh/modules/osx/data/migration-inventory.yaml` (2.909 líneas, `schema_version: 1`, anclado a `source_commit: 79b12435`) está confirmado correcto en todos los censos titulares por una auditoría independiente. Sus defectos son de scope/precisión, no de conteo: el `delete.effect` sobredimensionado (Defecto A), la dependencia transitiva solo en prosa (Defecto B), el `588` falsificado por `wc -l` (Defecto C), y dos hazards de esquema (D: colisión de nombre `total_write_calls`; E: `value_signatures` no alineado línea a línea).
- **El contrato declarado** del artefacto (`metadata.schema_contract`) instruye al consumidor a "fail loudly on `schema_version != 1`" y enumera las cinco claves de nivel superior que se chequean primero: `schema_version/source/source_commit/generated_for/scope_exclusions`. Ninguna de ellas cambia en este cambio.
- **El consumidor designado**, `darwin-system-config`, no existe todavía: es una delta sin archivar dentro del cambio activo `nix-darwin-support` (0 de 33 tareas), su spec no menciona `schema_version` ni el inventario, y la única referencia en código del repo a este archivo es una constante de path (`ZSH_OSX_MIGRATION_INVENTORY`, `zsh/modules/osx/config/base.zsh:15`). Es decir: el artefacto tiene cero lectores implementados hoy.
- **Mediciones propias que corrigen supuestos del brief**: `value_signatures` aparece 30 veces en el archivo — una vez como `value_signature_rule` y 29 veces dentro de `duplicated_keys` (7 conflictivos + 22 same-value), **no** en el censo de 130 claves; y `values` (el campo hermano) **ya está** alineado línea a línea con `source_lines` en todos los registros, incluido el de 4 ocurrencias `SOInputLineSettings`. Esto reduce el costo aparente del Hazard E, pero no su naturaleza (ver D4).
- **Convención de docs del repo**: `README.md` de módulo es generado (`task module-osx:readme` vía gomplate, enganchado a `task readme` en la raíz, `Taskfile.yml:313`), nunca se edita a mano. **Regla de OpenSpec sobre `## Purpose`**: un delta contra una capability existente NO lleva `## Purpose` — la spec principal ya tiene uno y el del delta se descarta en el archive; para cambiar el Purpose de una capability existente se edita directamente `openspec/specs/<capability-path>/spec.md`. El delta archivado `2026-09-28-add-osx-module` no es precedente: fue la *creación* de una capability nueva, cuya semilla de Purpose se copió a la spec principal recién creada en el archive (los dos textos son idénticos) — leerlo como precedente para un delta sobre una capability existente es precisamente la trampa. Consecuencia para este change: el fix de la cifra del Purpose viaja como edición directa de la spec principal, ejecutada en la fase de apply, y no dentro del delta `specs/osx-module/spec.md`.
- **Convención de `.codi/jira/`**: los docs de requisitos viven en `.codi/jira/<KEY>/requirements/<KEY>.md` (confirmado en los commits de RD-223, RD-230, RD-229); `.codi/jira/archived/` guarda prompts de codi (`task-*.md`), y el prompt de RD-219 ya está ahí (`task-migrar-zsh-osx-a-modulo-osx-en-dotfiles-GVB2870X.md`).

## Goals / Non-Goals

**Goals:**

1. Hacer que cada corrección de este cambio sea **verificable por máquina**, no solo mejor redactada: desglose estructurado del `delete`, registro estructurado de la llamada transitiva, declaraciones de semántica de esquema.
2. Preservar el contrato publicado del artefacto para su (futuro) consumidor: nada que hoy lea el archivo según el contrato escrito deje de poder leerlo.
3. Eliminar la clase de defecto, no solo la instancia: la colisión de nombre y la trampa de zip se cierran con reglas estructurales reutilizables, y las correcciones quedan registradas dentro del propio artefacto.
4. Dejar una sola cifra autoritativa para "los defaults postergados" en todo el repo, apuntando al inventario como fuente.

**Non-Goals:**

- Implementar, migrar o configurar los 130 defaults de dominio de usuario. La brecha de `darwin-system-config` (0/33) queda documentada y trazable, no cerrada — igual que en el proposal.
- Re-auditar el censo de 130 claves ni reescribir los 29 registros de `duplicated_keys`. El alcance de E es declarativo (D4), no de datos.
- Reescribir el doc de requisitos de RD-219 para que "diga la verdad" (D6 preserva el registro original anotado).
- Tocar runtime, agregar tooling de lint al repo, o corregir artefactos archivados (el design de `2026-09-28-add-osx-module` con sus "~150" queda histórico, por la misma política que D6).

## Decisions

### D1: `schema_version` se queda en 1; las correcciones se registran aditivamente

**Elección:** mantener `schema_version: 1` y (a) enmendar `metadata.schema_contract` con una política explícita de extensión aditiva, y (b) añadir `metadata.reconciliations`, una lista aditiva que registra cada campo corregido con `field/was/now/reason`:

```yaml
metadata:
  reconciliations:
  - field: metadata.source_file_lines
    was: 588
    now: 589
    reason: 589 logical lines; wc -l reports 588 (no trailing newline)
  - field: write_call_census.delete.effect
    was: 'the 13 writes at 106-132 are undone'
    now: <alcance acotado a NSGlobalDomain — ver D3>
    reason: delete is -g scoped; 11 app-domain writes persist
```

**Razón:**

1. **El job de un `schema_version` es compatibilidad de consumidor: señalar "la forma con la que te construiste puede no calzar".** No hay ningún lector instalado: `darwin-system-config` está en 0/33, su delta spec no menciona `schema_version` ni el inventario, y en el repo solo existe una constante de path. Un bump hoy comunica a nadie; la procedencia del contenido ya la dan `source_commit` + git.
2. **La superficie vigilada no cambia.** Las cinco claves que el contrato obliga a chequear conservan nombre, tipo y valor. El contrato publicado sigue siendo verdadero bajo v1.
3. **Un bump vuelve la promesa "fail loudly on != 1" de protectiva en bloqueante:** un lector escrito contra el contrato publicado hard-fallaría sobre datos *corregidos y correctos*. Mantener v1 preserva el significado de la promesa.
4. **`metadata.reconciliations` responde la objeción honesta** ("v1 ahora tiene dos formas en la historia"): el artefacto se posiciona como archivo de datos auto-descriptivo para un lector máquina, así que la distinción entre generación pre- y post-corrección debe vivir *dentro del archivo*, no solo en el historial de git.

**Alternativas consideradas:**

- **Bump a 2** — técnicamente defendible: este cambio agrega una clave (`source_sync_order_transitive`) y renombra otra (D4), que es forma, no solo valores. Rechazado: con cero consumidores el bump no compra seguridad y sí cuesta una reescritura del contrato, además de empujar una tarea "acepta la versión 2" hacia otro change activo (`nix-darwin-support`) sin compensación. El trigger para reevaluar queda escrito en la enmienda del contrato: un rediseño de forma de los censos (p. ej., registros por ocasión) es cuando `schema_version: 2` tiene audiencia.
- **Quedarse en 1 en silencio** (sin enmienda ni `reconciliations`) — rechazado: así es como se erosiona el significado de "v1"; la enmienda es lo que hace defendible la corrección en el lugar.

**Consecuencia de migración (explícita, en ambas ramas):** con v1 (lo elegido), ningún consumidor debe reaccionar; el contrato gana una oración de política aditiva y la lista de reconciliaciones. Con un bump hipotético, el contrato pasaría a `!= 2`, cualquier lector escrito contra el contrato publicado hard-fallaría, y el delta de `darwin-system-config` necesitaría una task explícita de aceptación de versión.

### D2: La dependencia transitiva es una lista hermana `source_sync_order_transitive`, no una anidación

**Elección:** nueva clave de nivel superior, lista de registros, siguiendo la familia `source_sync_order_*` ya existente (`_caller`, `_source`, `_notes` son hermanos de la lista plana):

```yaml
source_sync_order_transitive:
- caller: osx::keyboard
  caller_position: 3
  callee: osx::vim::keyboard
  member_of_source_sync_order: false
  source_line: 97
  source: zsh-osx/internal/base.zsh:97
  defaults_invocations:
    total: 14
    writes: 13
    deletes: 1
  carries_block: ApplePressAndHoldEnabled (source lines 106-134)
```

**Razón:**

1. **`source_sync_order` se queda como lista plana de 15 strings.** Es el campo más probable de consumirse programáticamente y un consumidor puede parsearlo posicionalmente; cambiar su tipo es el único movimiento verdaderamente rompedor disponible aquí.
2. **La forma sigue la convención del propio archivo.** La familia `source_sync_order_*` ya existe como claves hermanas; meter la lista dentro de un mapa anidado rompería esas tres claves existentes además de la lista.
3. **`caller_position: 3` permite join por índice** sin re-parsear nombres, y `member_of_source_sync_order: false` es la señal máquina que hoy no existe (el brief ya constató que la mención en prosa de `source_sync_order_notes` no alcanza). La nota en prosa se conserva pero se edita para apuntar a la clave estructurada: prosa como comentario, datos como autoridad.
4. **Los conteos son desglose, no prosa:** `13 + 1 = 14` es chequeable, y las 13 escrituras deben derivarse de `write_call_census.source_lines_by_scope.plain ∩ [106..132]` — derivación, no re-conteo manual. `carries_block` es un cross-reference, no una copia de las 14 líneas: una segunda lista de líneas es una segunda fuente que puede drift-ear, que es exactamente la enfermedad de este cambio.

**Alternativas consideradas:**

- **Anidar transición dentro de cada entrada del orden** (lista de records con `name` + `transitive_calls`) — rechazado: destruye el parseo posicional y las claves hermanas. Es breaking por diseño.
- **Mapa por nombre de área** (`source_sync_order_calls: {keyboard: [osx::vim::keyboard]}`) — rechazado: pierde línea de origen y conteo de invocaciones sin ganar nada; la lista de records generaliza a N aristas con campos uniformes si el análisis futuro encuentra más llamadas indirectas.

### D3: El `delete` gana un desglose estructurado; la prosa corregida se queda como resumen

**Elección:** `delete.effect` se reescribe acotado a NSGlobalDomain **y** el mapa `delete:` gana un hermano estructurado:

```yaml
  effect: <- prosa corregida: solo deshace los 2 writes de NSGlobalDomain ->
  effect_scope:
    undoes_source_lines: [106, 108]
    undoes_count: 2
    persists_source_lines: [110, 111, 112, 113, 116, 119, 120, 123, 126, 129, 132]
    persists_count: 11
    persists_value: -bool false
    persists_domains: <derivado de deferred_to_darwin_system_config.by_domain, no copiado a mano>
```

Más un back-reference en el único registro diferido afectado: el record `NSGlobalDomain/ApplePressAndHoldEnabled` de `deferred_to_darwin_system_config.by_domain` gana `deleted_by: zsh-osx/internal/base.zsh:134` y `final_state: unset`.

**Razón:**

1. **Corregir solo la prosa reincide en el mismo defecto.** La prosa es el guard débil que el propio artefacto critica — `value_signature_rule` existe precisamente porque "un warning en texto no alcanza para un lector máquina". La afirmación corregida debe ser chequeable: `undoes_count: 2` + `persists_count: 11` suman los 13 writes, y ambas listas son derivables de `deferred_to_darwin_system_config.by_domain` — la misma sección que hoy prueba la contradicción. Así, las dos secciones del artefacto no pueden volver a contradecirse sin romper una aritmética explícita.
2. **`effect` sigue siendo string (corregido); los datos van en una clave nueva.** Convertir un campo existente de string a mapa es un cambio de tipo — la misma clase de breaking que D2 evita en la lista de orden.
3. **El back-reference cierra la contradicción desde el otro lado.** Hoy el record diferido de NSGlobalDomain muestra `value: 'true'` (la primera ocurrencia, no el estado efectivo) con status `conflicting_duplicate` y ninguna mención del delete: un consumidor que lea solo esa sección cree que debe setear `true`. Con `deleted_by` + `final_state: unset` el consumidor ve que el estado final de la clave global es "ausente" (= default de macOS, press-and-hold habilitado), mientras los 11 writes de dominios de app persisten como `-bool false`. La entrada de `notes` sobre ApplePressAndHoldEnabled se rewordea a esa misma semántica, incluyendo la consecuencia práctica: reproducir los 13 writes sin el delete deja la clave global en `false` (invierte la intención solo en el scope global).
4. **Alcance acotado:** un solo record de `by_domain` se toca. La peculiaridad de fondo observada (records en conflicto llevan `value` singular = primera ocurrencia, no ganadora) queda anotada como observación, NO re-auditada — reabrir los 130 registros está fuera de Non-Goals.

**Alternativas consideradas:**

- **Reescribir solo la prosa de `effect` y `notes`** — rechazado por la razón 1: el defecto existía *porque* la prosa era la única forma de la afirmación.
- **Hacer de `effect` un mapa estructurado** — rechazado: rompe el tipo de un campo publicado para beneficio cero (el mapa nuevo aporta lo mismo como hermano).
- **Enumerar las 13 líneas dentro de `delete` sin back-reference** — rechazado: duplica datos de `source_lines_by_scope` sin conectar la sección que el consumidor realmente consume (`deferred_to_darwin_system_config`).

### D4: El hazard D se corrige ahora (rename); el hazard E se cierra estructuralmente ahora y sus datos no se tocan

**D — elección:** renombrar `deferred_to_darwin_system_config.total_write_calls` → `total_deferred_write_calls`. `write_call_census.total_write_calls: 171` queda intacto.

**Razón (D):**

1. La colisión es irremediable por documentación para un lector por nombre: dos campos distintos con el mismo nombre y valores correctos distintos (171 vs 164) — el calificador en prosa no la arregla, porque el lector con el bug ya no está leyendo prosa.
2. **Corregirlo después es estrictamente más caro.** Hoy el rename toca dos lugares de un archivo sin ninguna referencia externa (grep: solo las dos ocurrencias). En el momento en que `darwin-system-config` escriba su reader, el rename se vuelve un cambio breaking real. Este es el argumento decisivo para hacerlo en este cambio pese a no ser uno de los tres defectos del brief.
3. El rename no toca las cinco claves vigiladas de nivel superior, así que coexiste con D1 (queda registrado en `metadata.reconciliations`). Se renombra el de 164 y no el de 171 porque el 171 es la cifra titular nombrada en el lenguaje del scenario de la spec y en `ticket_corrections` — menor radio de impacto por la misma seguridad.

**Alternativas rechazadas (D):** mantener el nombre y añadir un calificador hermano (`scope: non-privileged`) — el lector correcto por path ya no tiene el bug; renombrar el de 171 — radio de impacto mayor sin ganancia.

**E — elección:** `value_signatures` **no está** alineado línea a línea y **no debe estarlo**. Se añade, junto al `value_signature_rule` prosa existente (que conserva su tipo string), un bloque aditivo:

```yaml
  value_signature_semantics:
    kind: set
    sorted: true
    deduplicated: true
    line_aligned: false
    zip_with_source_lines: forbidden
    line_aligned_alternative: values
```

**Razón (E):**

1. **La alineación es semánticamente indefinida, no cara.** `value_signatures` es un set ordenado y deduplicado por contrato: `SOInputLineSettings` tiene 4 líneas de origen y UNA firma a propósito (las 4 repiten el mismo valor efectivo `-dict-add -bool false` con sub-claves distintas). "Alinearlo" o duplica entradas —destruyendo la semántica de set de la que dependen `value_signature_rule` y la detección same-value (22 registros)— o es imposible. El rewrite de 29 registros que planteaba el brief no es un costo a pesar: es una operación sin resultado coherente. (Medición propia: el campo existe 30 veces en el archivo, todas en `duplicated_keys` — 7 + 22 — no en el censo de 130 claves.)
2. **La alternativa alineada ya existe y se nombra:** `values` está alineado con `source_lines` en los 29 registros (verificado incluso en el de 4 ocurrencias). El bloque estructural apunta a él, así que el lector que quiere zip usa `values` y el que quiere set usa `value_signatures`, y la prohibición es máquina-legible.
3. **Posición sobre diferir:** se difiere *el dato*, no el cierre del hazard — el cierre es la declaración estructural, que es aditiva y cabe en este cambio. La prosa sola era el guard débil desde la génesis del campo.

**Alternativa rechazada (E):** renombrar `value_signatures` → `value_signature_set` (señal más fuerte), pero renombra un campo referenciado por el texto de la regla y por el vocabulario del artefacto para un hazard cuya solución declarativa ya lo cierra; si al escribir el consumidor la declaración resulta insuficiente, el rename entonces es barato.

### D5: La cifra autoritativa es 130 claves únicas (164 llamadas); el fix vive en `README.yaml` (README regenerado) y en el Purpose de la spec principal

**Elección:**

- El texto "roughly 150" se corrige en `zsh/modules/osx/README.yaml` (única fuente) y `README.md` se regenera con `task module-osx:readme` — nunca se edita a mano (su propio header lo prohíbe; el task está enganchado a `task readme` raíz en `Taskfile.yml:313`).
- La redacción nueva lleva **ambas cifras con roles rotulados**: "130 unique user-domain defaults (164 non-privileged write calls)".
- **Cifra autoritativa: 130 claves únicas** (`deferred_to_darwin_system_config.total_unique_keys`).
- El `## Purpose` de la spec principal (`openspec/specs/osx-module/spec.md:5`) se corrige en la misma pasada por **edición directa de ese archivo**, que es el único camino válido para el Purpose de una capability existente. Esta edición ocurre al aplicar este change (ver razón 3), no ahora: los artefactos de este change son de planificación.

**Razón:**

1. Un "default" que `darwin-system-config` poseería es una **clave** `(domain, key)`, no una llamada: el propio `definition` del bloque define el conjunto dueñado como "collapsed to unique (domain, key) pairs" — 130. El 164 es el conteo de llamadas no privilegiadas *incluyendo duplicados que colapsan* (los 13 writes de ApplePressAndHold son 1 clave). La declarativa expresa cada clave una vez; 130 es lo que el módulo de Nix terminará configurando.
2. **El 150 no lo produce ninguna derivación del repo** — es el residuo de número redondo del ticket; 130 está 13% abajo, no es un redondeo. Y la fuente de la cifra nueva es el inventario (re-derivado del origen), nunca el ticket — la propia regla del header del artefacto.
3. **Ampliación de alcance, declarada:** el mismo "roughly 150" vive en el Purpose de la spec principal (`openspec/specs/osx-module/spec.md:5`) — la Fuente A, la primera verdad. Corregir solo el README crea una divergencia nueva 2-vs-1, la clase exacta que este cambio elimina; y la cifra corregida en ambos textos debe ser la 130/164 re-derivada del inventario, no el redondeo del ticket (razón 2). El mecanismo es la **edición directa de `openspec/specs/osx-module/spec.md` en la fase de apply**, y es legítimo: la regla de OpenSpec para cambiar el Purpose de una capability existente prescribe exactamente editar la spec principal en `openspec/specs/<capability-path>/spec.md`, no arrastrarlo en un delta. Esto se reconcilia con la frontera de planificación de este change — sus artefactos son de planificación, así que esa edición NO se hace ahora: se ejecuta como task al aplicar el change. El delta `specs/osx-module/spec.md` de este change queda sin `## Purpose` a propósito: en un delta sobre una capability existente ese Purpose se ignora en el archive, es decir, un task que aparenta éxito mientras no cambia nada. El delta archivado `2026-09-28-add-osx-module` no es precedente en contrario: ese cambio *creó* la capability, y su Purpose viajó a la spec principal porque el archive copia la semilla de una capability nueva hacia una spec que no existía; leerlo como autoridad para una capability ya existente es exactamente la trampa.

**Alternativas consideradas:** corregir solo el README (rechazado, razón 3); dejar "~150" en prosa como aproximación en ambos (rechazado, 130 ≠ ~150); tocar los "~150" del design archivado (rechazado: los artefactos archivados son históricos, misma política que D6).

### D6: El doc de requisitos de RD-219 se anota como superseded; no se reescribe y no se mueve

**Elección:** banner al inicio de `.codi/jira/RD-219/requirements/RD-219.md` (antes del Issue Metadata) con marcador SUPERSEDED que nombra las autoridades, más una tabla de reconciliación fila por afirmación obsoleta. El cuerpo del doc queda intacto. Filas de la tabla: residiencia del scope (migrar los 171 writes → solo residuo, postergado a `darwin-system-config`); descomposición (14 archivos por área → 5 archivos por concern de ciclo de vida); sudo (13 → 12); `scutil` (4 → 3; la línea 501 es un `sudo defaults write` al plist de SMB, no un scutil); funciones públicas (3 → 4, `osx::packages` es pública); conteo de líneas (588 → 589). Cada fila apunta a su autoridad: la spec `openspec/specs/osx-module/spec.md` para scope y requirements, el inventario para los conteos, y el design archivado `2026-09-28-add-osx-module` (D1) para el rationale del layout de 5 archivos.

**Razón:**

1. **Es un artefacto de requisitos: el registro de lo pedido.** El valor de este change es la divergencia auditable — la historia de "por qué 5 archivos y no 14" está documentada y deliberada en el design archivado; reescribir el doc original destruye el rastro de por qué existió la divergencia.
2. **El repo ya modela corrección-sin-borrado**: `metadata.ticket_corrections` del propio inventario corrige errores del ticket sin editar el ticket. La anotación extiende ese patrón a la tercera fuente.
3. **La investigación de `.codi/jira/` descarta moverlo**: `.codi/jira/archived/` guarda prompts de codi (`task-*.md`), y el prompt de RD-219 ya está archivado ahí; mover los requisitos rompería la convención `<KEY>/requirements/<KEY>.md` (confirmada en los commits de RD-223/RD-230/RD-229) y rompería el linkage por ticket.

**Alternativas consideradas:** corrección in-place (rechazado: el doc dejaría de distinguirse de requisitos contemporáneos — history loss silencioso); mover a `.codi/jira/archived/` (rechazado, razón 3); borrarlo (rechazado de plano).

## Risks / Trade-offs

**[R-CONTRACT] → Un consumidor escrito contra el contrato publicado "fail loudly on != 1" podría haberse construido contra la forma pre-corrección de v1.** Mitigación: no existe tal consumidor hoy (0/33, delta spec sin mención de `schema_version`, solo una constante de path en el repo) y este cambio lo verifica antes de tocar nada; la enmienda del `schema_contract` declara la política aditiva y `metadata.reconciliations` hace distinguibles las dos generaciones de v1 dentro del archivo. Si en el futuro aparece un lector real, D1 ya dejó escrito el trigger para el bump.

**[R-DRIFT] → Los campos estructurados nuevos (desglose del delete, record transitivo) repiten números que ya viven en otras secciones y pueden divergir en una re-análisis futura del origen.** Mitigación: todo campo nuevo se **deriva** de secciones existentes (`by_domain` para las 11 escrituras persistentes, `source_lines_by_scope.plain` para las 13), nunca se cuenta a mano; las invariantes aritméticas quedan explícitas (`2 + 11 = 13`, `13 + 1 = 14`) para que un drift rompa una suma visible, no una prosa.

**[R-ZIP] → Un consumidor que haga zip de `value_signatures` con `source_lines` sigue pudiendo mapear mal los ganadores (Hazard E pre-existente, mitigado parcialmente).** Mitigación: `zip_with_source_lines: forbidden` + `line_aligned_alternative: values` lo convierten en regla máquina-legible, no en advertencia. Riesgo residual aceptado: el cierre es declarativo, no impide el zip físico; se recurre al rename (alternativa de D4) si al escribir el consumidor el campo se muestra ambiguo pese a la declaración.

**[R-SCOPE] → El cambio toca solo datos/docs mientras la brecha real (130 defaults sin configurador) sigue abierta; un revisor podría esperar que este change la cierre.** Mitigación: Non-Goals del proposal y de este design la nombran explícitamente; el inventario corregido es precisamente lo que hace la brecha trazable para `darwin-system-config`, que es el alcance declarado. El trade de acoplarse a ese change activo ya fue aceptado en el design original (R-NIX) y no se renegocia aquí.

**[R-README] → `README.yaml` corregido pero `README.md` sin regenerar deja el artefacto generado fuera de sincronía, y nadie falla por eso.** Mitigación: la regeneración `task module-osx:readme` es un paso de verificación en el Migration Plan, comprobable con grep (el README generado debe contener 130/164 y cero "roughly 150"); igual que en el cambio original, el include y la dependencia del task ya están registrados, así que no hay task fantasma.

**[R-ANNOTATE] → Alguien lee el doc de RD-219 anotado y aun así sigue sus criteria obsoletos.** Mitigación: el banner va al inicio del archivo, antes del Issue Metadata, con marcador SUPERSEDED y las autoridades nombradas; la tabla de reconciliación nombra cada criterion afectado (8, 12, y los conteos), de modo que localizar la corrección para un criterion dado es una lectura, no una auditoría.

## Migration Plan

Solo datos y documentación; rollback = un `git revert` (cero consumidores implementados, cero runtime).

1. **Artefacto (`zsh/modules/osx/data/migration-inventory.yaml`)** — en este orden, porque los pasos 2-4 derivan de secciones que el paso 1 deja consistentes:
   1. Defecto C: comentario de cabecera y `metadata.source_file_lines` → 589, con la nota del newline final para que nadie lo "corrija" de vuelta a 588.
   2. Defecto A: reescribir `delete.effect` acotado; añadir `delete.effect_scope`; rewordear la entrada de `notes` sobre ApplePressAndHoldEnabled; añadir `deleted_by` + `final_state` al record `NSGlobalDomain` de `by_domain`.
   3. Defecto B: añadir `source_sync_order_transitive`; editar la nota en prosa de `source_sync_order_notes` para que apunte a la clave estructurada.
   4. Hazards: renombrar el `total_write_calls` diferido; añadir `value_signature_semantics` junto a `value_signature_rule`.
   5. D1: enmendar `metadata.schema_contract` (política aditiva + trigger del bump futuro) y añadir `metadata.reconciliations`.
2. **Verificación de invariantes** (comandos, no tooling nuevo): `2 + 11 = 13`; `13 + 1 = 14`; el censo titular `158 + 7 + 6 = 171` intacto; `source_sync_order` sigue siendo exactamente 15 strings; el YAML parsea; grep confirma un solo `total_write_calls` en el archivo (el de `write_call_census`).
3. **Cifra autoritativa en el README (D5, superficie 1):** editar `zsh/modules/osx/README.yaml` reemplazando "roughly 150" por "130 unique user-domain defaults (164 non-privileged write calls)"; regenerar `README.md` con `task module-osx:readme` — nunca se edita a mano.
4. **Cifra autoritativa en el Purpose de la spec principal (D5, superficie 2):** editar directamente `openspec/specs/osx-module/spec.md` y reemplazar en `## Purpose` el "~150" por la misma cifra 130/164. Este archivo sí se toca como parte de aplicar este change: es el camino que OpenSpec prescribe para el Purpose de una capability existente, y como los artefactos de este change son de planificación, la edición se ejecuta en la fase de apply (no en la escritura del delta).
5. **Verificación cruzada de la cifra (ambas superficies):** grep con patrón `roughly 150|~150` ausente de `zsh/modules/osx/README.yaml`, del `README.md` regenerado y de `openspec/specs/osx-module/spec.md`; `130` y `164` presentes en el par README (`README.yaml` y `README.md`).
6. **Anotación del doc de requisitos (D6):** banner + tabla en `.codi/jira/RD-219/requirements/RD-219.md`.
7. **Spec delta de `osx-module`** (requirement "Inventario de migración versionado" endurecida: precisión de scope + registro estructural de llamadas transitivas) — escrito según `proposal.md — Capabilities`; este design no lo duplica. Sin `## Purpose`: la capability ya existe y su Purpose se corrige en el paso 4, por edición directa de la spec principal.
8. **`graphify update .`** al final, por la regla del repo para cambios de código/datos.

## Open Questions

1. **¿El reader futuro de `darwin-system-config` debe assertar las invariantes aritméticas nuevas (2+11=13, 13+1=14) al cargar el inventario, o solo consumir los campos?** Diferible: pertenece a las tasks de `nix-darwin-support`, no cambia ningún artefacto de este change.
2. **Si un re-análisis del origen encuentra MÁS aristas transitivas (otras funciones de área llamando helpers), ¿el modelo se queda como lista de aristas o crece a una sección de grafo de llamadas general?** Diferible: la fuente actual tiene exactamente una arista, la forma de lista ya acomoda N aristas con campos uniformes, y un rediseño solo tendría sentido con datos que todavía no existen.
