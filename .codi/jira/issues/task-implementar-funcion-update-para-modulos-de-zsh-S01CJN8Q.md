# Task: Implementar función update para módulos de zsh

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Implementar una función update para actualizar cualquier módulo de zsh/modules/ y documentarla en docs/guides/, con herdr::update como caso de ejemplo.
- component: Documentation
- labels: []
- parentEpic: RD-30
- issueKey:

## Scenario

Los módulos en zsh/modules/ no cuentan con una función `update` para actualizarse a su última versión.
Por ejemplo, el módulo herdr no tiene una función `herdr::update` que permita reinstalar/actualizar la herramienta usando su instalador oficial.

Se requiere un patrón genérico de función `update` aplicable a cualquier módulo de zsh/modules/, implementado primero en herdr usando el instalador curl oficial.

### Acceptance Tests

1. Implementar una función `update` genérica para módulos de zsh/modules/.
2. Implementar `herdr::update` en zsh/modules/herdr/ que ejecute el instalador oficial: `curl -fsSL https://herdr.dev/install.sh | sh`.
3. Verificar que `herdr::update` retorna éxito (0) cuando herdr queda disponible en PATH tras la actualización.
4. Verificar que `herdr::update` retorna error (1) si la instalación falla o el binario no queda en PATH.
5. Documentar el patrón de función `update` en docs/guides/.

### Sources

- https://herdr.dev/install.sh
- https://github.com/codiplab/dotfiles.git