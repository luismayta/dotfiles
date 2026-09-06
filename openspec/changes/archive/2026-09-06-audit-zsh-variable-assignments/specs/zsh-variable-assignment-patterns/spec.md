## Purpose

Establece el patrón correcto para asignación de variables en módulos zsh: `:=` para valores por defecto que pueden ser sobrescritos, `=` para overrides obligatorios de plataforma.

## ADDED Requirements

### Requirement: Variables por defecto usan asignación condicional
Los archivos `base.zsh` en cada módulo DEBEN usar el operador `:=` para establecer valores por defecto de variables de configuración.

#### Scenario: Variable no definida previamente
- **WHEN** una variable no está definida en el entorno
- **THEN** el operador `:=` asigna el valor por defecto

#### Scenario: Variable definida por usuario
- **WHEN** una variable ya tiene valor asignado por el usuario en `zshrc`
- **THEN** el operador `:=` preserva el valor del usuario

### Requirement: Overrides de plataforma usan asignación incondicional
Los archivos OS-específicos (`osx.zsh`, `linux.zsh`) DEBEN usar el operador `=` (sin dos puntos) para sobreescribir valores por defecto cuando el override es obligatorio.

#### Scenario: macOS con binario diferente
- **WHEN** el módulo se carga en macOS y el binario tiene nombre diferente (ej: `hx` vs `helix`)
- **THEN** el archivo `osx.zsh` usa `=` para forzar el override

#### Scenario: Linux con valor por defecto
- **WHEN** el módulo se carga en Linux
- **THEN** se mantiene el valor por defecto de `base.zsh`

### Requirement: Detección de Homebrew usa asignación condicional
Los archivos OS-específicos DEBEN usar `:=` dentro de bloques `if` para detección de rutas Homebrew, ya que cada rama es independiente.

#### Scenario: Apple Silicon detectado
- **WHEN** `/opt/homebrew/bin/hx` existe
- **THEN** `ZSH_HELIX_BIN_PATH` se establece a `/opt/homebrew/bin`

#### Scenario: Intel detectado
- **WHEN** `/usr/local/bin/hx` existe pero Apple Silicon no
- **THEN** `ZSH_HELIX_BIN_PATH` se establece a `/usr/local/bin`
