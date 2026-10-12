## MODIFIED Requirements

### Requirement: Inventario de migración versionado
Dado que la mayor parte del origen se difiere a la configuración declarativa, el módulo SHALL entregar un inventario de migración versionado como artefacto consumible por el cambio declarativo. El inventario SHALL registrar el censo de llamadas de escritura, las claves duplicadas y sus conflictos, las operaciones privilegiadas, las claves sin efecto en macOS actual o cambiadas de mecanismo, y el orden de invocación del origen. Todo dato SHALL precisar su scope real y derivarse de la fuente.

#### Scenario: El artefacto existe en el directorio de datos del módulo
- **WHEN** se inspecciona el directorio de datos del módulo
- **THEN** el inventario de migración versionado SHALL estar presente ahí

#### Scenario: Registra el censo de llamadas de escritura desglosado por forma
- **WHEN** se lee el censo del inventario de migración
- **THEN** SHALL registrar 171 llamadas de escritura desglosadas en 158 escrituras `defaults write` planas, 7 escrituras `sudo defaults write` y 6 escrituras `defaults -currentHost write`
- **AND** SHALL registrar además 1 llamada `defaults delete`

#### Scenario: Enumera las claves con valores conflictivos y ambas ubicaciones
- **WHEN** se lee la sección de claves duplicadas del inventario de migración
- **THEN** SHALL registrar 29 pares `(domain, key)` duplicados
- **AND** SHALL identificar 7 de ellos como conflictivos, anotando ambos valores y ambas ubicaciones del origen con la forma `zsh-osx/internal/base.zsh:NNN`

#### Scenario: Registra que una variable del origen se usa pero nunca se asigna
- **WHEN** se lee el inventario de migración
- **THEN** SHALL registrar que una variable del origen es referenciada 4 veces y asignada cero veces

#### Scenario: Registra el orden de invocación del origen
- **WHEN** se lee el inventario de migración
- **THEN** SHALL registrar el orden de invocación del origen que decide qué valor gana

#### Scenario: El efecto registrado del `defaults delete` se acota a su dominio real
- **WHEN** se lee `write_call_census.delete.effect` junto con sus `notes`
- **THEN** SHALL declarar que el `defaults delete` de la línea 134, con scope `-g` (NSGlobalDomain), solo deshace los 2 escritos de NSGlobalDomain de las líneas 106 y 108
- **AND** SHALL declarar que los 11 escritos restantes a dominios de app en las líneas 110-132 persisten como `-bool false`
- **AND** la sección SHALL ser consistente con `deferred_to_darwin_system_config.by_domain`

#### Scenario: Las magnitudes registradas se derivan de la fuente
- **WHEN** se leen `metadata.source_file_lines`, el comentario de cabecera y `source_sync_order_source` del inventario
- **THEN** el inventario SHALL registrar 589 líneas lógicas para `zsh-osx/internal/base.zsh`
- **AND** el comentario de cabecera SHALL declarar 589 líneas, no 588
- **AND** la cifra SHALL ser consistente con `source_sync_order_source: zsh-osx/internal/base.zsh:573-589`

## ADDED Requirements

### Requirement: Registro estructurado de llamadas transitivas del orden de origen
Además del orden de invocación, el inventario SHALL registrar como campos estructurados, legibles por máquina, toda llamada indirecta alcanzable desde ese orden: función llamadora, función llamada, línea de origen, número de invocaciones de `defaults` que arrastra y declaración explícita de que la llamada no es miembro de la lista de orden. Este registro SHALL complementar la lista de orden sin modificarla.

#### Scenario: La dependencia de `osx::vim::keyboard` se registra como dato estructurado
- **WHEN** se lee la sección de llamadas transitivas del inventario
- **THEN** SHALL registrarse que `osx::keyboard` invoca a `osx::vim::keyboard` en la línea 97 de `zsh-osx/internal/base.zsh`
- **AND** SHALL declararse que `osx::vim::keyboard` NO es miembro de `source_sync_order`
- **AND** SHALL registrarse que esa llamada arrastra 14 invocaciones de `defaults`: 13 escrituras y 1 `defaults delete`

#### Scenario: El registro estructural complementa la lista de orden sin alterarla
- **WHEN** se lee `source_sync_order` junto con el registro de llamadas transitivas
- **THEN** `source_sync_order` SHALL seguir conteniendo exactamente 15 entradas
- **AND** la dependencia de `osx::vim::keyboard` SHALL estar disponible en campos estructurados, no solo en prosa

#### Scenario: Un consumidor del orden no pierde el bloque ApplePressAndHoldEnabled
- **WHEN** un consumidor deriva las funciones a ejecutar a partir de `source_sync_order` y del registro de llamadas transitivas
- **THEN** el bloque completo de `ApplePressAndHoldEnabled`, con sus 14 invocaciones de `defaults`, SHALL seguir representado
- **AND** el registro SHALL atribuirlo a `osx::keyboard`, en la posición 3 del orden, como llamada indirecta no listada
