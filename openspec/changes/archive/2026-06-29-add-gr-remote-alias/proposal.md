## Why

Agregar un alias `gr` para `git remote` que permita consultar rápidamente las URLs de los remotos configurados mediante `gr -v`. Actualmente no existe un alias para `git remote`, lo que obliga a tipear el comando completo o usar `g remote -v`.

## What Changes

- Agregar alias `gr='git remote'` en `pkg/alias.zsh`
- Esto permite usar `gr -v` para listar las URLs de los remotos, `gr add <name> <url>`, etc.

## Capabilities

### New Capabilities
- `git-remote-alias`: Nuevo alias `gr` que mapea a `git remote`, siguiendo el patrón de aliases existentes en el módulo (g→git, gl→pull, gp→push, gc→commit, etc.)

### Modified Capabilities

*Ninguna.*

## Impact

- Archivo afectado: `zsh/modules/git/pkg/alias.zsh`
- Sin cambios en APIs, dependencias, o sistemas externos
- Sin breaking changes
