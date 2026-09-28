## Purpose

Módulo zsh en `zsh/modules/osx/` que cubre únicamente las operaciones de macOS que una configuración de sistema declarativa no puede expresar: escrituras host-scoped, operaciones privilegiadas degradadas a procedimientos manuales, operaciones destructivas gateadas, refresco explícito de procesos en runtime, y el reporte de la política de screen-lock. Los ~150 defaults declarativos de dominio de usuario NO pertenecen a esta capability: son de `darwin-system-config`.

## ADDED Requirements

### Requirement: Descubrimiento y carga del módulo
El módulo SHALL ser descubierto automáticamente por el loop de iteración de directorios de `zsh/zshrc`, sin requerir ninguna entrada de registro. Una variable de guarda SHALL evitar una segunda carga, de modo que sourcear el entry point dos veces emita el aviso `Loading module: osx` exactamente una vez. En plataformas que no sean macOS el módulo SHALL quedar deshabilitado antes de que su capa de implementación cargue, de modo que ninguna invocación de `defaults` pueda ocurrir en Linux. El módulo SHALL además ser deshabilitable por nombre a través de la variable de entorno que el shell ya consulta para módulos deshabilitados.

#### Scenario: Carga fresca emite el aviso una vez
- **WHEN** una shell interactiva nueva arranca en macOS con el módulo no deshabilitado
- **THEN** el aviso `Loading module: osx` SHALL ser emitido exactamente una vez
- **AND** la implementación del módulo SHALL estar cargada

#### Scenario: Doble source emite el aviso una vez
- **WHEN** el entry point del módulo es sourceado dos veces en la misma sesión
- **THEN** el aviso `Loading module: osx` SHALL ser emitido exactamente una vez en total
- **AND** el segundo sourceado SHALL ser un no-op

#### Scenario: En Linux no ocurre ninguna invocación de `defaults`
- **WHEN** una shell interactiva nueva arranca en Linux con el módulo no deshabilitado por nombre
- **THEN** el módulo SHALL quedar deshabilitado antes de cargar su capa de implementación
- **AND** ninguna invocación de `defaults` SHALL ocurrir durante la carga

#### Scenario: Deshabilitación por nombre previene la carga sin error
- **WHEN** el nombre del módulo está listado en la variable de entorno de módulos deshabilitados
- **THEN** el módulo SHALL no cargar
- **AND** el arranque de la shell SHALL completarse sin error

### Requirement: Escrituras host-scoped deduplicadas
El módulo SHALL aplicar las escrituras de preferencias por host que una configuración declarativa de sistema completo no puede expresar. Donde el origen exprese la misma clave por host más de una vez, el módulo SHALL escribir cada clave exactamente una vez. El conjunto aplicado SHALL ser reportado para que el usuario pueda ver qué cambió.

#### Scenario: Una clave duplicada en el origen se escribe una vez
- **WHEN** una clave por host aparece dos veces en el origen con el mismo valor
- **THEN** el módulo SHALL emitir exactamente una escritura para esa clave
- **AND** el valor efectivamente escrito SHALL ser el del origen

#### Scenario: El conjunto aplicado se reporta tras una corrida
- **WHEN** una corrida del módulo completa sus escrituras host-scoped
- **THEN** el conjunto de claves efectivamente aplicadas SHALL ser reportado al usuario

#### Scenario: Una segunda corrida no produce escrituras duplicadas
- **WHEN** el módulo se ejecuta dos veces consecutivas
- **THEN** la segunda corrida SHALL NOT emitir ninguna escritura repetida de una clave ya aplicada en la primera

### Requirement: Las operaciones privilegiadas no ejecutan `sudo`
El módulo SHALL NOT invocar `sudo` bajo ninguna condición. Cada operación privilegiada que herede SHALL ser expuesta en su lugar como un procedimiento manual documentado que nombre el objetivo exacto, el valor exacto y el comando que el usuario SHALL ejecutar por su cuenta, junto con una advertencia. El módulo SHALL NOT intentar una escritura privilegiada cuando el valor que escribiría esté vacío o no asignado.

#### Scenario: Una sincronización completa sin escalamiento de privilegios
- **WHEN** una corrida del módulo completa todas las operaciones
- **THEN** ninguna invocación de `sudo` SHALL ejecutarse
- **AND** la corrida SHALL completarse sin escalamiento de privilegios

#### Scenario: Cada operación privilegiada heredada se reporta como procedimiento manual
- **WHEN** una corrida del módulo alcanza una de las operaciones privilegiadas heredadas
- **THEN** el módulo SHALL reportarla como procedimiento manual skipped, nombrando el objetivo exacto, el valor exacto y el comando completo que el usuario debe ejecutar
- **AND** SHALL emitir una advertencia que declare el paso manual requerido

#### Scenario: Una operación privilegiada con valor no asignado se reporta como skipped
- **WHEN** una operación privilegiada requiere un valor que está vacío o nunca fue asignado
- **THEN** el módulo SHALL reportarla como skipped
- **AND** no SHALL escribirse ningún valor

### Requirement: Las operaciones destructivas están gateadas
Las operaciones destructivas SHALL nunca ejecutarse como parte de una corrida rutinaria. La reconstrucción de Launch Services SHALL requerir un opt-in explícito y SHALL estar documentada como afecta los dominios local, system y user. Borrar el array persistente de aplicaciones del Dock SHALL requerir confirmación explícita que nombre la consecuencia, y SHALL soportar un override no interactivo para uso scriptable.

#### Scenario: Sin opt-in la reconstrucción se omite con advertencia
- **WHEN** una corrida rutinaria se ejecuta sin el opt-in de reconstrucción de Launch Services
- **THEN** la reconstrucción SHALL ser omitida
- **AND** el módulo SHALL emitir una advertencia que la declare

#### Scenario: Con opt-in la reconstrucción se ejecuta
- **WHEN** el opt-in de reconstrucción de Launch Services está habilitado
- **THEN** la reconstrucción de Launch Services SHALL ejecutarse
- **AND** la documentación del módulo SHALL declarar que afecta los dominios local, system y user

#### Scenario: El wipe del Dock se omite cuando la confirmación es rechazada
- **WHEN** el wipe del array persistente de aplicaciones del Dock se solicita y la confirmación es rechazada
- **THEN** el wipe SHALL ser omitido
- **AND** el array persistente de aplicaciones del Dock SHALL permanecer intacto

#### Scenario: El wipe del Dock se omite cuando la confirmación no está disponible
- **WHEN** el wipe del array persistente de aplicaciones del Dock se solicita en una sesión no interactiva donde la confirmación no puede obtenerse
- **THEN** el wipe SHALL ser omitido

#### Scenario: El override ejecuta el wipe sin preguntar
- **WHEN** el override no interactivo del wipe del Dock está habilitado
- **THEN** el wipe del array persistente de aplicaciones del Dock SHALL ejecutarse sin solicitar confirmación

### Requirement: El refresco de runtime es explícito, no automático
Aplicar configuración declarativa deja a los procesos ya corriendo sosteniendo estado obsoleto. El módulo SHALL exponer una operación de refresco explícita que reinicie los procesos de sistema afectados para que una sesión viva refleje la configuración recién aplicada. El refresco SHALL NOT dispararse automáticamente en el arranque de la shell ni como efecto secundario de cargar el módulo, y SHALL NOT dispararse implícitamente por una corrida rutinaria.

#### Scenario: Cargar el módulo no reinicia nada
- **WHEN** el módulo es cargado durante el arranque de la shell
- **THEN** ningún proceso SHALL ser reiniciado

#### Scenario: Invocar el refresco reinicia los procesos afectados y los reporta
- **WHEN** el usuario invoca explícitamente la operación de refresco
- **THEN** el módulo SHALL reiniciar cada proceso de sistema afectado
- **AND** SHALL reportar cada proceso reiniciado

#### Scenario: Una corrida rutinaria no realiza ningún reinicio
- **WHEN** una corrida rutinaria del módulo completa sus operaciones
- **THEN** el módulo SHALL NOT reiniciar ningún proceso

### Requirement: La política de screen-lock se reporta, no se escribe
El origen expresa el requerimiento de password de screen-lock en dos lugares con valores de delay conflictivos, de modo que el ajuste efectivo depende del orden de ejecución. El módulo SHALL detectar que el ajuste documentado está administrado fuera del mecanismo soportado, SHALL reportar los valores efectivos actuales, y SHALL NOT escribirlos. El módulo SHALL documentar el mecanismo soportado en su lugar.

#### Scenario: Los valores efectivos se reportan cuando difieren de la intención documentada
- **WHEN** una corrida del módulo encuentra que el valor efectivo de screen-lock difiere del valor documentado
- **THEN** el módulo SHALL reportar el valor efectivo actual
- **AND** SHALL reportar que existe drift respecto de la intención documentada

#### Scenario: No hay escritura a la preferencia deprecada
- **WHEN** el módulo procesa la política de screen-lock
- **THEN** el módulo SHALL NOT escribir las preferencias de screen-lock en el dominio del usuario

#### Scenario: El mecanismo soportado se nombra en la salida
- **WHEN** el módulo reporta el drift de screen-lock
- **THEN** la salida SHALL nombrar el mecanismo soportado que administra ese ajuste

### Requirement: Inventario de migración versionado
Dado que la mayor parte del origen se difiere a la configuración declarativa, el módulo SHALL entregar un inventario de migración versionado como artefacto de datos, consumible por el cambio de configuración declarativa. El inventario SHALL registrar el censo total de llamadas de escritura, toda clave duplicada, toda clave duplicada con valores conflictivos, las operaciones privilegiadas, las claves que ya no surten efecto en macOS actual, las claves cuyo mecanismo cambió, y el orden de invocación del origen que decide qué valor gana.

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

### Requirement: Conformidad con las convenciones del core
Toda la salida orientada al usuario SHALL pasar por los message helpers existentes del proyecto. El módulo SHALL NOT usar primitivas directas de `echo` ni de `print`. Las comprobaciones de disponibilidad de binarios SHALL pasar por los helpers de existencia y de ensure existentes del proyecto, y el módulo SHALL NOT reimplementar ningún helper de core existente. El módulo SHALL pasar el quality gate de shell del repositorio con suprimidos únicamente los códigos globalmente excluidos por el repositorio.

#### Scenario: Una corrida no produce salida cruda fuera de los message helpers
- **WHEN** una corrida del módulo emite su salida
- **THEN** toda la salida visible SHALL producirse a través de los message helpers del proyecto
- **AND** el módulo SHALL NOT emitir `echo` ni `print` directos

#### Scenario: Un binario faltante se detecta por el helper de core
- **WHEN** el módulo necesita un binario que no está presente
- **THEN** la detección SHALL realizarse a través del helper de existencia de core
- **AND** el módulo SHALL NOT reimplementar la comprobación

#### Scenario: Una comprobación estática del módulo no reporta violaciones
- **WHEN** el quality gate de shell del repositorio se ejecuta sobre el módulo
- **THEN** el módulo SHALL reportar cero violaciones con los códigos globalmente excluidos por el repositorio suprimidos

### Requirement: Registro de README generado
El módulo SHALL estar registrado en el task file raíz tanto con el include por módulo como con la dependencia agregada de README, en posición alfabética, para que el README generado del módulo sea producido por el task de README estándar del repositorio. Los metadatos del README del módulo SHALL declarar el módulo como exclusivo de macOS.

#### Scenario: El task estándar de README produce el README del módulo
- **WHEN** se ejecuta el task estándar de README del repositorio
- **THEN** el README del módulo SHALL ser producido a partir de sus metadatos

#### Scenario: Los metadatos del módulo declaran la plataforma macOS-only
- **WHEN** se leen los metadatos del README del módulo
- **THEN** SHALL declarar que el módulo es exclusivo de macOS

#### Scenario: Las dos entradas de registro están en posición alfabética
- **WHEN** se inspecciona el task file raíz
- **THEN** el include del módulo SHALL estar registrado en posición alfabética entre los includes vecinos
- **AND** la dependencia del módulo en el task agregado de README SHALL estar registrada en posición alfabética
